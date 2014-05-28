Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 7464A7F57
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 07:31:22 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 6D17D304066
	for <xfs@oss.sgi.com>; Wed, 28 May 2014 05:31:22 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 2oHPpK2UBJo92s0c for <xfs@oss.sgi.com>;
	Wed, 28 May 2014 05:31:17 -0700 (PDT)
Message-ID: <5385D715.9080103@sandeen.net>
Date: Wed, 28 May 2014 07:31:17 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH 2/2,
	RFC] mkfs.xfs: don't call blkid_get_topology on regular files
References: <53852A05.5040006@redhat.com> <53852A98.7000809@sandeen.net>
	<20140528054034.GB13166@infradead.org>
In-Reply-To: <20140528054034.GB13166@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 5/28/14, 12:40 AM, Christoph Hellwig wrote:
> On Tue, May 27, 2014 at 07:15:20PM -0500, Eric Sandeen wrote:
>> If we encounter a target that's really a regular file,
>> even without "-d file..." on the cmdline, call
>> platform_findsizes() instead of blkid_get_topology to
>> try to discover the "sector size" via the fsgeom() call.
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> ---
>>
>> diff --git a/mkfs/xfs_mkfs.c b/mkfs/xfs_mkfs.c
>> index 37c05a9..74180c9 100644
>> --- a/mkfs/xfs_mkfs.c
>> +++ b/mkfs/xfs_mkfs.c
>> @@ -454,12 +454,26 @@ static void get_topology(
>>  	struct fs_topology	*ft,
>>  	int			force_overwrite)
>>  {
>> -	if (!xi->disfile) {
>> -		const char *dfile = xi->volname ? xi->volname : xi->dname;
>> +	int is_a_file = 0;
>> +	struct stat statbuf;
>> +	char *dfile = xi->volname ? xi->volname : xi->dname;
>>  
>> +	if (!stat(dfile, &statbuf) && S_ISREG(statbuf.st_mode))
>> +		is_a_file = 1;
>> +
>> +	if (!xi->disfile && !is_a_file) {
> 
> Why do need both xi->disfile and a local flag/  Why do we do the
> that even if xi->disfile is set?

Good point that we don't need to do the stat if the old disfile flag
is already set.

But "disfile" implies a lot of other things, and comes from specifying
"-d file,..." on the cmdline.  If you point mkfs straight at a file,
disfile is NOT set, so I check it here explicitly.

The dichotomy between "mkfs.xfs -dfile,name=$FOO" and "mkfs.xfs $FOO"
is a weird one, and should probably just go away in the long run...

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
