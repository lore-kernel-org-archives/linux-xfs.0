Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:50238 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751303AbdKMWWF (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 13 Nov 2017 17:22:05 -0500
Subject: Re: [PATCH v3 2/2] fiemap: Implement ranged query
References: <1510588073-5665-1-git-send-email-nborisov@suse.com>
 <1510588073-5665-2-git-send-email-nborisov@suse.com>
 <20171113214457.GX4094@dastard>
 <e97f774f-a3ae-04c0-4b74-6a4f26e72674@suse.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <3491ce98-b744-90de-e01b-83f13abadfa9@sandeen.net>
Date: Mon, 13 Nov 2017 16:22:03 -0600
MIME-Version: 1.0
In-Reply-To: <e97f774f-a3ae-04c0-4b74-6a4f26e72674@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Nikolay Borisov <nborisov@suse.com>, Dave Chinner <david@fromorbit.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org, eguan@redhat.com, darrick.wong@oracle.com

On 11/13/17 4:05 PM, Nikolay Borisov wrote:
> 
> 
> On 13.11.2017 23:44, Dave Chinner wrote:
>> On Mon, Nov 13, 2017 at 05:47:53PM +0200, Nikolay Borisov wrote:
>>> Currently the fiemap implementation of xfs_io doesn't support making ranged
>>> queries. This patch implements the '-r' parameter, taking up to 2 arguments - 
>>> the starting offset and the length of the region to be queried. This also 
>>> requires changing of the final hole range is calculated. Namely, it's now being
>>> done as [last_logical, logical addres of next extent] rather than being
>>> statically determined by [last_logical, filesize].
>>>
>>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
>>> ---
>>> V3: 
>>>  * Fixed a bug where incorrect extent index was shown if we didn't print a 
>>>  hole. This was due to statically returning 2 at the end of print_(plain|verbose)
>>>  Now, the actual number of printed extents inside the 2 functions is used. 
>>>  This bug is visible only with the -r parameter
>>>
>>>  * Fixed a bug where 1 additional extent would be printed. This was a result of 
>>>  the aforementioned bug fix, since now printing function can return 1 and still
>>>  have printed an extent and no hole. This can happen when you use -r parameter,
>>>  this is now fixed and a comment explaining it is put. 
>>>
>>>  * Reworked the handling of the new params by making them arguments to the 
>>>  -r parameter. 
>>>
>>> V2:
>>>  * Incorporated Daricks feedback - removed variables which weren't introduced
>>>   until the next patch as a result the build with this patch was broken. This is 
>>>   fixed now
>> .....
>>
>>> @@ -256,9 +269,12 @@ fiemap_f(
>>>  	int		tot_w = 5;	/* 5 since its just one number */
>>>  	int		flg_w = 5;
>>>  	__u64		last_logical = 0;
>>> +	size_t		fsblocksize, fssectsize;
>>>  	struct stat	st;
>>>  
>>> -	while ((c = getopt(argc, argv, "aln:v")) != EOF) {
>>> +	init_cvtnum(&fsblocksize, &fssectsize);
>>> +
>>> +	while ((c = getopt(argc, argv, "aln:vr")) != EOF) {
>>
>> Ok, you're not telling gotopt that "-r" has parameters, so....
>>
>>>  		switch (c) {
>>>  		case 'a':
>>>  			fiemap_flags |= FIEMAP_FLAG_XATTR;
>>> @@ -272,6 +288,50 @@ fiemap_f(
>>>  		case 'v':
>>>  			vflag++;
>>>  			break;
>>> +		case 'r':
>>> +			/* Parse the first option which is mandatory */
>>> +			if (optind < argc && argv[optind][0] != '-') {
>>> +				off64_t start_offset = cvtnum(fsblocksize,
>>> +							      fssectsize,
>>> +							      argv[optind]);
>>> +				if (start_offset < 0) {
>>> +					printf("non-numeric offset argument -- "
>>> +					       "%s\n", argv[optind]);
>>> +					return 0;
>>> +				}
>>> +				last_logical = start_offset;
>>> +				optind++;
>>> +			} else {
>>> +				fprintf(stderr, _("Invalid offset argument for"
>>> +						  " -r\n"));
>>> +				exitcode = 1;
>>> +				return 0;
>>> +			}
>>> +
>>> +			if (optind < argc) {
>>> +				/* first check if what follows doesn't begin
>>> +				 * with '-' which means it would be a param and
>>> +				 * not an argument
>>> +				 */
>>> +				if (argv[optind][0] == '-') {
>>> +					optind--;
>>> +					break;
>>> +
>>> +				}
>>> +
>>> +				off64_t length = cvtnum(fsblocksize,
>>> +							fssectsize,
>>> +							argv[optind]);
>>> +				if (length < 0) {
>>> +					printf("non-numeric len argument --"
>>> +					       " %s\n", argv[optind]);
>>> +					return 0;
>>> +				}
>>> +				len = length;
>>> +				range_limit = true;
>>> +			}
>>> +			break;
>>
>> .... this is pretty nasty because you're having to check if the next
>> option should be parsed by the main loop or not. This assumes that
>> getopt is giving us the options in the order they were presented on
>> the command line, which is not a good assumption to make as glibc
>> can mutate the order as it parses the listi of know options and
>> arguments.
>>
>> Given that "-r" is the only option that has parameters, then this
>> can be massively simplified just by noting we've seen the rflag, and
>> leaving the non-arg parameter parsing to after the end of the loop.
>> i.e.:
> 
> 
> You are right this is a bit ugly, but it seems more consistend to me,
> rather than something like
> 
> xfs_io -c "fiemap -r -n 10 -v 4k 10k" for example. And the reason why
> I'm using this hackish way and not declaring r as r: in getopt is
> because getopt doesn't recognise when a parameter takes more than 1
> argument.

Sorry for chiming in so late after all the go-rounds, but:

Why not just drop -r entirely, and make fiemap go into ranged mode iff a
range is specified at the end of the command, i.e.:

fiemap [ -alv ] [ -n nx ] [ offset length ]

and if no offset/length is specified, map the whole file.   You can parse
the optional last 2 arguments just like pread, write, sync_range, sendfile,
or a host of other commands already do (though some are not optional.)

There are /many/ other xfs_io commands that take offset & length at the
end, so this usage should be very familiar to users.

-Eric

