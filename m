Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3654E7F53
	for <xfs@oss.sgi.com>; Tue, 10 Sep 2013 17:41:12 -0500 (CDT)
Date: Tue, 10 Sep 2013 17:41:11 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH 0/2] xfs: log recovery buffer fixes
Message-ID: <20130910224111.GX1935@sgi.com>
References: <1378081921-18570-1-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1378081921-18570-1-git-send-email-david@fromorbit.com>
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
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On Mon, Sep 02, 2013 at 10:31:59AM +1000, Dave Chinner wrote:
> Folks, these two patches make sure log recovery correctly identifies
> the type of buffer being recovered. The buffer log format type field
> is not always being set correctly, and that leads to invalid remote
> symlink and directory blocks after recovery as they hav enot had the
> CRC recalculated after being recovered.

Applied these 2.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
