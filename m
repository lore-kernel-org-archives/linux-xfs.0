Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-pf1-f195.google.com ([209.85.210.195]:46877 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730332AbeKEBbd (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 4 Nov 2018 20:31:33 -0500
Date: Mon, 5 Nov 2018 00:15:54 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH v1] xfs/050: make it passed for dax 2 MiB alignment test
Message-ID: <20181104161554.GF12788@desktop>
References: <1540522074-20036-1-git-send-email-xifeng@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1540522074-20036-1-git-send-email-xifeng@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: XiaoLi Feng <xifeng@redhat.com>
Cc: esandeen@redhat.com, jmoyer@redhat.com, fstests@vger.kernel.org, xzhou@redhat.com, linux-xfs@vger.kernel.org

On Fri, Oct 26, 2018 at 10:47:54AM +0800, Xiaoli Feng wrote:
> From: xiaoli feng <xifeng@redhat.com>
> 
> This case is failed for dax 2MiB alignment test. When test "push past
> the hard block limit" in this case, the quota bhard is 4000kb, and
> try to create 4096kb in dax fs. dax only create 2048kb because of 2MiB
> alignment. But there is a check that the file size must > 3400kb(bhard
> * 85%). So there are two method to fix it. One is to decrease bhard
> size. Second is to descreate minimum size. The minimum is hard to define.
> So I choose first method.

Adding linux-xfs to cc list for review from xfs folks. Thanks a lot!

Eryu

> ---
>  tests/xfs/050     |  4 ++--
>  tests/xfs/050.out | 60 +++++++++++++++++++++++++++----------------------------
>  2 files changed, 32 insertions(+), 32 deletions(-)
> 
> diff --git a/tests/xfs/050 b/tests/xfs/050
> index 788ed7f..d2ca477 100755
> --- a/tests/xfs/050
> +++ b/tests/xfs/050
> @@ -43,8 +43,8 @@ _scratch_mount
>  bsize=$(_get_file_block_size $SCRATCH_MNT)
>  _scratch_unmount
>  
> -bsoft=$(( 200 * $bsize ))
> -bhard=$(( 1000 * $bsize ))
> +bsoft=$(( 100 * $bsize ))
> +bhard=$(( 500 * $bsize ))
>  isoft=4
>  ihard=10
>  
> diff --git a/tests/xfs/050.out b/tests/xfs/050.out
> index 725cd79..6a7af1a 100644
> --- a/tests/xfs/050.out
> +++ b/tests/xfs/050.out
> @@ -12,23 +12,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  
>  *** report initial settings
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the soft inode limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** push past the soft block limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** push past the hard inode limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** push past the hard block limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] =OK= 200 1000 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] =OK= 100 500 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** unmount
>  *** group
> @@ -44,23 +44,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  
>  *** report initial settings
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the soft inode limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** push past the soft block limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** push past the hard inode limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** push past the hard block limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] =OK= 200 1000 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] =OK= 100 500 0 [7 days] 10 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** unmount
>  *** uqnoenforce
> @@ -76,23 +76,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  
>  *** report initial settings
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the soft inode limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the soft block limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the hard inode limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
>  
>  *** push past the hard block limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 1200 200 1000 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
> +[NAME] 1200 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
>  
>  *** unmount
>  *** gqnoenforce
> @@ -108,23 +108,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  
>  *** report initial settings
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the soft inode limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the soft block limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the hard inode limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
>  
>  *** push past the hard block limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 1200 200 1000 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
> +[NAME] 1200 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
>  
>  *** unmount
>  *** pquota
> @@ -140,23 +140,23 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  
>  *** report initial settings
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the soft inode limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 5 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** push past the soft block limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [7 days] 6 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** push past the hard inode limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** push past the hard block limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] =OK= 200 1000 0 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
> +[NAME] =OK= 100 500 0 [7 days] 9 4 10 00 [7 days] 0 0 0 00 [--------]
>  
>  *** unmount
>  *** pqnoenforce
> @@ -172,22 +172,22 @@ realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX
>  
>  *** report initial settings
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 1 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the soft inode limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 0 200 1000 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 0 100 500 00 [--------] 5 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the soft block limit
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [--------] 6 4 10 00 [--------] 0 0 0 00 [--------]
>  
>  *** push past the hard inode limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 300 200 1000 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
> +[NAME] 300 100 500 00 [--------] 18 4 10 00 [--none--] 0 0 0 00 [--------]
>  
>  *** push past the hard block limit (expect EDQUOT)
>  [ROOT] 0 0 0 00 [--------] 3 0 0 00 [--------] 0 0 0 00 [--------]
> -[NAME] 1200 200 1000 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
> +[NAME] 1200 100 500 00 [--none--] 18 4 10 00 [--none--] 0 0 0 00 [--------]
>  
>  *** unmount
> -- 
> 1.8.3.1
> 
