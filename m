Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:60426 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727087AbeK0J4y (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 27 Nov 2018 04:56:54 -0500
Subject: Re: [PATCH] mkfs.xfs: null-terminate symlinks created via protofile
References: <a7246562-e851-dfc4-ea3f-3b4dd64aca5b@redhat.com>
 <20181126225537.GB6792@magnolia>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <29aed6d6-ee75-8bae-cdaa-0ccc7a81ca9c@sandeen.net>
Date: Mon, 26 Nov 2018 17:01:10 -0600
MIME-Version: 1.0
In-Reply-To: <20181126225537.GB6792@magnolia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>, Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>, Zorro Lang <zlang@redhat.com>

On 11/26/18 4:55 PM, Darrick J. Wong wrote:
> On Mon, Nov 26, 2018 at 04:39:30PM -0600, Eric Sandeen wrote:
>> Now that we have a symlink verifier which checks that in-memory
>> symlink names are null-terminated, be sure we do that when we
>> create them via the mkfs protofile.
>>
>> We only want to null-terminate inline data if it's a symlink;
>> we only ever /call/ newfile() with "dolocal" for symlinks, so
>> rename that function argument for clarity.
>>
>> Zorro found this by running xfs/019 on an s390x machine, it
>> failed with:
>>
>>  Metadata corruption detected at 0x101214a, inode 0x89 data fork
>>
>> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
>> Reported-by: Zorro Lang <zlang@redhat.com>
>> ---
>>
>> diff --git a/mkfs/proto.c b/mkfs/proto.c
>> index 1cd5436..d76c80d 100644
>> --- a/mkfs/proto.c
>> +++ b/mkfs/proto.c
>> @@ -15,7 +15,7 @@ static char *getstr(char **pp);
>>  static void fail(char *msg, int i);
>>  static struct xfs_trans * getres(struct xfs_mount *mp, uint blocks);
>>  static void rsvfile(xfs_mount_t *mp, xfs_inode_t *ip, long long len);
>> -static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, int dolocal, int logit,
>> +static int newfile(xfs_trans_t *tp, xfs_inode_t *ip, int symlink, int logit,
>>  			char *buf, int len);
>>  static char *newregfile(char **pp, int *len);
>>  static void rtinit(xfs_mount_t *mp);
>> @@ -220,7 +220,7 @@ static int
>>  newfile(
>>  	xfs_trans_t	*tp,
>>  	xfs_inode_t	*ip,
>> -	int		dolocal,
>> +	int		symlink,
>>  	int		logit,
>>  	char		*buf,
>>  	int		len)
>> @@ -236,7 +236,9 @@ newfile(
>>  
>>  	flags = 0;
>>  	mp = ip->i_mount;
>> -	if (dolocal && len <= XFS_IFORK_DSIZE(ip)) {
>> +	if (symlink && len <= XFS_IFORK_DSIZE(ip)) {
>> +		/* Copy the name's trailing NULL as well */
>> +		len += 1;
> 
> We set di_size to len later in this function, which means that we now
> write out a symlink with a size larger than the symlink target, right?

sonova...

> --D
> 
>>  		libxfs_idata_realloc(ip, len, XFS_DATA_FORK);
>>  		if (buf)
>>  			memmove(ip->i_df.if_u1.if_data, buf, len);
>>
> 
