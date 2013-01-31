Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 9E52F7F4E
	for <xfs@oss.sgi.com>; Thu, 31 Jan 2013 14:34:39 -0600 (CST)
Date: Thu, 31 Jan 2013 14:34:38 -0600
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH] xfsdump: zero bs_forkoff, don't fill in the value
Message-ID: <20130131203438.GR27055@sgi.com>
References: <50EB2073.1040609@gmail.com> <50EB2814.2090500@sandeen.net>
	<50EB3268.2080004@sandeen.net> <50EB3DF7.3010100@hardwarefreak.com>
	<20130107213739.GU27055@sgi.com> <50EC567E.2020607@sandeen.net>
	<50EC57FD.9040601@sandeen.net>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <50EC57FD.9040601@sandeen.net>
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
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Fugazzi99 <fugazzi99@gmail.com>, Stan Hoeppner <stan@hardwarefreak.com>, xfs@oss.sgi.com

Hi Eric,

On Tue, Jan 08, 2013 at 11:31:41AM -0600, Eric Sandeen wrote:
> In xfsdump 3.1.2 I explicitly added the bs_forkoff member
> to this structure; I tried to be good and explicitly fill
> in a value.  However, previously it was initialized to
> zero, (by virtue of being missing) and now we're giving it
> a value (which is ignored by restore, other than to checksum
> it).
> 
> By putting in a non-zero value, I broke checksumming
> when an xfsdump with a non-zero forkoff was restored
> by an older xfsrestore that doesn't know about the field.
> Fill in 0 to fix backwards compatibility.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>
> Reported-by: Fugazzi99 <fugazzi99@gmail.com>
> ---
> 
> diff --git a/dump/content.c b/dump/content.c
> index 9a36fe1..ac19021 100644
> --- a/dump/content.c
> +++ b/dump/content.c
> @@ -4928,7 +4928,7 @@ copy_xfs_bstat(bstat_t *dst, xfs_bstat_t *src)
>  	dst->bs_extents = src->bs_extents;
>  	dst->bs_gen = src->bs_gen;
>  	dst->bs_projid_lo = src->bs_projid_lo;
> -	dst->bs_forkoff = src->bs_forkoff;
> +	dst->bs_forkoff = 0;

I think I understand this now.

A legacy xfs_repair would not have bs_forkoff in

read_filehdr
  xlate_filehdr
    xlate_bstat
      IXLATE(bs1, bs2, bs_forkoff);

And bs_pad is copied without any translation.  This works fine as long as
bs_forkoff and bs_projid_hi are 0.  In the failure case bs_forkoff was nonzero
and changed the checksum because it was not translated.   I could not reproduce
the checksum failure on a filesystem without xattrs because bs_forkoff was
always 0.

*** Get set up with an xattr:

# touch /mnt/scratch/file
# setfattr -h -n user.testattr -v testvalue /mnt/scratch/file

*** Dump the filesystem with 3.1.2:

# xfsdump - /mnt/scratch > dump-with-attribute-and-3.1.2.out
xfsdump: using file dump (drive_simple) strategy
xfsdump: version 3.1.2 (dump format 3.0)
...
xfsdump: Dump Status: SUCCESS

*** Restore with 3.1.0, and print out bs_pad:

# xfsrestore -f dump-with-attribute-and-3.1.2.out /mnt/test 
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.0 (dump format 3.0) - type ^C for status and control
...
xfsrestore: reading directories
read_filehdr pad is 0 0 0 0 0 0 0 0 0 0 0 0 0 0 
read_filehdr pad is 0 78 0 0 0 0 0 0 0 0 0 0 0 0 
xfsrestore: WARNING: bad file header checksum
...
xfsrestore: Restore Status: INCOMPLETE

*** Restore with 3.1.0, translating bs_pad where bs_forkoff lives:

# xfsrestore -f dump-with-attribute-and-3.1.2.out /mnt/test
xfsrestore: using file dump (drive_simple) strategy
xfsrestore: version 3.1.0 (dump format 3.0) - type ^C for status and control
...
xfsrestore: reading directories
read_filehdr pad is 0 0 0 0 0 0 0 0 0 0 0 0 0 0
read_filehdr pad is 78 0 0 0 0 0 0 0 0 0 0 0 0 0
xfsrestore: 1 directories and 1 entries processed
xfsrestore: directory post-processing
xfsrestore: restoring non-directory files
read_filehdr pad is 78 0 0 0 0 0 0 0 0 0 0 0 0 0
read_filehdr pad is 0 0 0 0 0 0 0 0 0 0 0 0 0 0
xfsrestore: restore complete: 0 seconds elapsed
xfsrestore: Restore Summary:
xfsrestore:   stream 0 /root/xfsdump/dump-with-attribute-and-3.1.2.out OK (success)
xfsrestore: Restore Status: SUCCESS

:!quilt di
Index: xfsdump/restore/content.c
===================================================================
--- xfsdump.orig/restore/content.c
+++ xfsdump/restore/content.c
@@ -8038,6 +8038,7 @@ read_filehdr( drive_t *drivep, filehdr_t
        intgen_t nread;
        intgen_t rval;
        filehdr_t tmpfh;
+       int i;
 
        nread = read_buf( ( char * )&tmpfh,
                          sizeof( *fhdrp ),
@@ -8078,6 +8079,16 @@ read_filehdr( drive_t *drivep, filehdr_t
                              "corrupt file header\n") );
                        return RV_CORRUPT;
                }
+               i = bstatp->bs_pad[0];
+               bstatp->bs_pad[0] = bstatp->bs_pad[1];
+               bstatp->bs_pad[1] = i;
+
+               printf("%s pad is ", __func__);
+               for (i = 0; i < 14; i++) {
+                       printf("%x ", bstatp->bs_pad[i]);
+               }
+               printf("\n");
+
                if ( !is_checksum_valid( fhdrp, FILEHDR_SZ )) {
                        mlog( MLOG_NORMAL | MLOG_WARNING, _(
                              "bad file header checksum\n") );

Now all new dumps will have zeroed bs_pad[0,1] so it doesn't matter that they
aren't xlated.  Your fix looks good.  

Reviewed-by: Ben Myers <bpm@sgi.com>

I'll pull this in immediately.

Thanks,
Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
