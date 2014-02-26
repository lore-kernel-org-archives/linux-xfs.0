Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 4D1F17F50
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 20:18:38 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 2810830406A
	for <xfs@oss.sgi.com>; Tue, 25 Feb 2014 18:18:35 -0800 (PST)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id AAA6Lvsg4EGNwSr8 for
	<xfs@oss.sgi.com>; Tue, 25 Feb 2014 18:18:34 -0800 (PST)
Message-ID: <530D4EE1.6040601@redhat.com>
Date: Tue, 25 Feb 2014 20:18:09 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfs: clean up xfs_set_maxicount & use in growfs
References: <530C29C7.90001@redhat.com> <20140226021114.GA26022@infradead.org>
In-Reply-To: <20140226021114.GA26022@infradead.org>
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
Cc: xfs-oss <xfs@oss.sgi.com>

On 2/25/14, 8:11 PM, Christoph Hellwig wrote:
> On Mon, Feb 24, 2014 at 11:27:35PM -0600, Eric Sandeen wrote:
>> xfs_set_maxicount() overflowed fairly easily for large filesystems
>> and large maxicount; we started out by multiplying dblocks by
>> the percentage, *then* dividing by 100, and never checked for
>> an overflow.  The calculations were also, IMHO, a little hard
>> to follow.
> 
> Would be useful to get this test case into xfstests..

Your'e bot, aren't you.  ;)

yeah you're right.  I went down this path by starting a testcase
for 3-patches-ago, and got here.  That one can be sent soon, and
sure, it'd be worth doing this too.

>> -STATIC void
>> +void
>>  xfs_set_maxicount(xfs_mount_t *mp)
>>  {
>>  	xfs_sb_t	*sbp = &(mp->m_sb);
>> -	__uint64_t	icount;
>> +	__uint64_t	iblocks;
> 
> Seems like this could move into the if clause below.
> 
>> @@ -388,6 +388,7 @@ extern int	xfs_mod_incore_sb_batch(xfs_mount_t *, xfs_mod_sb_t *,
>>  extern int	xfs_mount_log_sb(xfs_mount_t *, __int64_t);
>>  extern struct xfs_buf *xfs_getsb(xfs_mount_t *, int);
>>  extern int	xfs_readsb(xfs_mount_t *, int);
>> +void		xfs_set_maxicount(xfs_mount_t *mp);
>>  extern void	xfs_freesb(xfs_mount_t *);
>>  extern int	xfs_fs_writable(xfs_mount_t *);
>>  extern int	xfs_sb_validate_fsb_count(struct xfs_sb *, __uint64_t);
> 
> A missing extern while all other prototypes around it have one seems
> rather odd.

Sure does!

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
