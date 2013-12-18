Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 014B229DF8
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 23:20:37 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CE8A98F8081
	for <xfs@oss.sgi.com>; Tue, 17 Dec 2013 21:20:33 -0800 (PST)
Received: from mx4-phx2.redhat.com (mx4-phx2.redhat.com [209.132.183.25]) by
	cuda.sgi.com with ESMTP id wDHI11FSg6IHNDcC for
	<xfs@oss.sgi.com>; Tue, 17 Dec 2013 21:20:32 -0800 (PST)
Date: Wed, 18 Dec 2013 00:20:29 -0500 (EST)
From: Boris Ranto <branto@redhat.com>
Message-ID: <1243674646.8335146.1387344029069.JavaMail.root@redhat.com>
In-Reply-To: <1387318722-3050-9-git-send-email-jayr@google.com>
References: <1387318722-3050-1-git-send-email-jayr@google.com>
	<1387318722-3050-9-git-send-email-jayr@google.com>
Subject: Re: [PATCH v2 09/12] xfstests: skip generic/076 which cannot work
	on tmpfs
MIME-Version: 1.0
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
To: Junho Ryu <jayr@google.com>
Cc: tytso@mit.edu, hughd@google.com, xfs@oss.sgi.com

Hi,

here, you were probably looking for -b option (that tests if its argument is a block device) instead of -d option (that tests if its argument is a directory). Otherwise, this patch would skip the test case for an arbitrary file system.

-Boris

----- Original Message -----
> Skip generic/076 which tests concurrent access while testing tmpfs
> because there are other tests cover the case using fsstress.
> 
> Signed-off-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Theodore Ts'o <tytso@mit.edu>
> Signed-off-by: Junho Ryu <jayr@google.com>
> ---
> 
> v2: check whether SCRATCH_DEV is a block device instead of checking whether
>     FSTYP is tmpfs.
> 
>  tests/generic/076 | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/tests/generic/076 b/tests/generic/076
> index a53840f..7ab2fbc 100755
> --- a/tests/generic/076
> +++ b/tests/generic/076
> @@ -57,6 +57,8 @@ _supported_os IRIX Linux
>  
>  _require_scratch
>  
> +[ -d "$SCRATCH_DEV" ] || _notrun "this test requires block device"
> +
>  echo "*** init fs"
>  
>  rm -f $seqres.full
> --
> 1.8.5.1
> 
> 

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
