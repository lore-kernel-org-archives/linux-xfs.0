Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 24 Feb 2008 20:42:54 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m1P4gfbQ028869
	for <xfs@oss.sgi.com>; Sun, 24 Feb 2008 20:42:47 -0800
Subject: Re: [REVIEW] fix mkfs.xfs agcount between 64 and 128MB
From: "Barry Naujok" <bnaujok@sgi.com>
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
MIME-Version: 1.0
References: <op.t61916fp3jf8g2@pc-bnaujok.melbourne.sgi.com> <ncc8x19y8ca.fsf@sgi.com>
Date: Mon, 25 Feb 2008 15:44:52 +1100
Message-ID: <op.t62cs2c63jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <ncc8x19y8ca.fsf@sgi.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Niv Sardi <xaiki@cxhome.ath.cx>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Mon, 25 Feb 2008 15:21:25 +1100, Niv Sardi <xaiki@cxhome.ath.cx> wrote:

>
> What's wrong with this:


diff --git a/xfsprogs/mkfs/xfs_mkfs.c b/xfsprogs/mkfs/xfs_mkfs.c
index e15d667..13884f9 100644
--- a/xfsprogs/mkfs/xfs_mkfs.c
+++ b/xfsprogs/mkfs/xfs_mkfs.c
@@ -422,7 +422,7 @@ calc_default_ag_geometry(
  		count = 1;
  		goto done;
  	} else if (dblocks < MEGABYTES(128, blocklog)) {
-		blocks = MEGABYTES(16, blocklog);
+		blocks = MEGABYTES(32, blocklog);
  		goto done;
  	}

And what happens between 16 and 32MB?
