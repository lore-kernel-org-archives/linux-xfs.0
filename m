Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 630EE29DFB
	for <xfs@oss.sgi.com>; Fri, 23 Aug 2013 08:28:34 -0500 (CDT)
Message-ID: <52176380.9070806@sgi.com>
Date: Fri, 23 Aug 2013 08:28:32 -0500
From: Rich Johnston <rjohnston@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs_io: v7 add the lseek() SEEK_DATA/SEEK_HOLE support
References: <20130822213148.224998379@sgi.com> <52169488.2040303@sandeen.net>
	<521762F4.4050603@sgi.com>
In-Reply-To: <521762F4.4050603@sgi.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Mark Tinguely <tinguely@sgi.com>
Cc: Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

On 08/23/2013 08:26 AM, Mark Tinguely wrote:
> On 08/22/13 17:45, Eric Sandeen wrote:
>> On 8/22/13 4:31 PM, Mark Tinguely wrote:
>>
>>> Add the lseek SEEK_DATA/SEEK_HOLE support into xfs_io.
>>> The result from the lseek() call will be printed to the output.
>>> For example:
>>>
>>> xfs_io>  seek -h 609k
>>> HOLE    630784
>>>
>>> Signed-off-by: Mark Tinguely<tinguely@sgi.com>
>>> ---
>>>   version 7 or 8 - Eric what number is this?
>>
>> Go for 13, for luck!
>>
>> I think this looks ok, I won't torture you any longer.  If there's
>> anything
>> to fix up when it really gets used in earnest we can do it then.
>>
>> (it crossed my mind that for the "-r" and "-a" invocations it might be
>> good to print
>> out the offset which was sent for each SEEK_* "whence," but *shrug*)
>>
>> Thanks for all the iterations,
>>
>> Reviewed-by: Eric Sandeen<sandeen@redhat.com>
>
> Rich, hold off on commit, I can quickly add the whence. We can see how
> she sails.
>
> --Mark
>
OK

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
