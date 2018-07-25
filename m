Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:39038 "EHLO sandeen.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731437AbeGZACq (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 25 Jul 2018 20:02:46 -0400
Subject: Re: [PATCH v3] libxfs: add more bounds checking to sb sanity checks
References: <20180713131003.31121-1-billodo@redhat.com>
 <20180725213336.16263-1-billodo@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <bee8d307-e372-2b67-e46e-f54b6dd81379@sandeen.net>
Date: Wed, 25 Jul 2018 15:48:51 -0700
MIME-Version: 1.0
In-Reply-To: <20180725213336.16263-1-billodo@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Bill O'Donnell <billodo@redhat.com>, linux-xfs@vger.kernel.org



On 7/25/18 2:33 PM, Bill O'Donnell wrote:
> +	/* Additional sb sanity checks for writes */
> +	if (!error) {
> +		if (sb.sb_fdblocks > sb.sb_dblocks ||
> +		    sb.sb_ifree > sb.sb_icount) {
> +			    xfs_notice(mp, "SB sanity check failed");
> +			    error = -EFSCORRUPTED;
> +		}
> +	}

I had kind of had it in my head that Dave suggested testing not
only sb_fdblocks & sb_ifree but also validating sb_icount against
sb_dblocks ... would that make sense?  something like:

+		if (sb.sb_fdblocks > sb.sb_dblocks ||
+		    sb.sb_icount / sb.sb_inopblock > sb.sb_dblocks) ||
+		    sb.sb_ifree > sb.sb_icount) {
+			    xfs_notice(mp, "SB sanity check failed");

because all 3 go into the statfs calculations which went wonky
in the original report?  (xfs_sb_verify has done some sanity
checks on sb_inopblock by the time we get here.)

Also, a comment about why these checks are only for write, and are not
simply in xfs_mount_validate_sb() would be good, since that obviously
wasn't obvious to me at first.  o_O :)

-Eric
