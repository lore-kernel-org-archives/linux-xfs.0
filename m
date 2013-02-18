Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id AFE0D7F50
	for <xfs@oss.sgi.com>; Mon, 18 Feb 2013 15:24:49 -0600 (CST)
Message-ID: <51229C21.4040102@sgi.com>
Date: Mon, 18 Feb 2013 15:24:49 -0600
From: Mark Tinguely <tinguely@sgi.com>
MIME-Version: 1.0
Subject: Re: xfs speculative preallocation -- fragmentation issue with sparse
	file handling?
References: <51229835.5090707@redhat.com>
In-Reply-To: <51229835.5090707@redhat.com>
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
To: Brian Foster <bfoster@redhat.com>
Cc: Dave Chinner <dchinner@redhat.com>, xfs@oss.sgi.com

On 02/18/13 15:08, Brian Foster wrote:
> Hi guys,
>
> I was running a sanity check of my quota throttling stuff rebased
> against the updated speculative prealloc algorithm:
>
> a1e16c26 xfs: limit speculative prealloc size on sparse files
>
> ... and ran into an interesting behavior on my baseline test (quota
> disabled).
>
> The test I'm running is a concurrent write of 32 files (10GB each) via
> iozone (I'm not testing performance, just using it as a concurrent writer):
>
> iozone -w -c -e -i 0 -+n -r 4k -s 10g -t 32 -F /mnt/data/file{0..31}
>
> ... what I noticed is that from monitoring du during the test,
> speculative preallocation seemed to be ineffective. From further
> tracing, I observed that imap[0].br_blockcount in
> xfs_iomap_eof_prealloc_initial_size() was fairly consistently maxed out
> at around 32768 blocks (128MB).
>
> Without the aforementioned commit, preallocation occurs as expected and
> the files result in 7-9 extents after the test. With the commit, I'm in
> the 70s to 80s range of number of extents with a max extent size of
> 128MB. A couple examples of xfs_bmap output are appended to this
> message. It seems like initial fragmentation might be throwing the
> algorithm out of whack..?
>
> Brian

... the patched version increases in doubles

+	if (imap[0].br_startblock == HOLESTARTBLOCK)
+		return 0;

     vvvvvv
+	if (imap[0].br_blockcount <= (MAXEXTLEN >> 1))
+		return imap[0].br_blockcount;
     ^^^^^^

+	return XFS_B_TO_FSB(mp, XFS_ISIZE(ip));
+}

have you experimented without the middle if statement.
If I remember correctly when I reviewed the code, that should be moving
code closer to the original code; namely use the file size as the
preallocation value.

--Mark.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
