Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 8844C7F63
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 20:07:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 755F18F8035
	for <xfs@oss.sgi.com>; Thu,  3 Oct 2013 18:07:41 -0700 (PDT)
Received: from ipmail05.adl6.internode.on.net (ipmail05.adl6.internode.on.net
	[150.101.137.143]) by cuda.sgi.com with ESMTP id
	oZDbhF2joMhjpRjq for <xfs@oss.sgi.com>;
	Thu, 03 Oct 2013 18:07:40 -0700 (PDT)
Date: Fri, 4 Oct 2013 11:07:37 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH] xfstests generic/260: get correct trimmed bytes
Message-ID: <20131004010737.GE4446@dastard>
References: <1380801437-1191-1-git-send-email-eguan@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1380801437-1191-1-git-send-email-eguan@redhat.com>
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
To: Eryu Guan <eguan@redhat.com>
Cc: xfs@oss.sgi.com

On Thu, Oct 03, 2013 at 07:57:17PM +0800, Eryu Guan wrote:
> Newer fstrim(1) reports trimmed bytes differently, e.g.
> 
> new fstrim: /mnt/ext4: 9.7 GiB (10411118592 bytes) trimmed
> old fstrim: /mnt/ext4: 10411118592 bytes were trimmed
> 
> generic/260 reports syntax error
> 
>     +./tests/generic/260: line 111: [: 9.7: integer expression expected
>     +./tests/generic/260: line 121: [: 9.7: integer expression expected
>     +./tests/generic/260: line 183: [: 9.7: integer expression expected
> 
> Fix it so 260 passes with both old and new fstrim.
> 
> Signed-off-by: Eryu Guan <eguan@redhat.com>
> ---
>  tests/generic/260 | 10 ++++------
>  1 file changed, 4 insertions(+), 6 deletions(-)
> 
> diff --git a/tests/generic/260 b/tests/generic/260
> index dc8b822..bc9eb3b 100755
> --- a/tests/generic/260
> +++ b/tests/generic/260
> @@ -104,9 +104,8 @@ _scratch_mount
>  # This is a bit fuzzy, but since the file system is fresh
>  # there should be at least (fssize/2) free space to trim.
>  # This is supposed to catch wrong FITRIM argument handling
> -out=$($FSTRIM_PROG -v -o10M $SCRATCH_MNT)
> -nopref=${out##*: }
> -bytes=${nopref%% *}
> +out=$($FSTRIM_PROG -v -o10M $SCRATCH_MNT | egrep -o "[0-9]+ bytes")
> +bytes=${out%% *}

Can you add this as a "_filter_fstrim" function to common/filter
with a comment explaining what version of fstrim the output changed
in?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
