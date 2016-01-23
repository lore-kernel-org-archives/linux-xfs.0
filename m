Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id BE7617F51
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 19:30:30 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AC9768F8059
	for <xfs@oss.sgi.com>; Fri, 22 Jan 2016 17:30:30 -0800 (PST)
Received: from ZenIV.linux.org.uk (zeniv.linux.org.uk [195.92.253.2]) by
	cuda.sgi.com with ESMTP id 12bGfyvsNHTqBELw (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 22 Jan 2016 17:30:25 -0800 (PST)
Date: Sat, 23 Jan 2016 01:30:21 +0000
From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH] vfs: abort dedupe loop if fatal signals are pending
Message-ID: <20160123013021.GL17997@ZenIV.linux.org.uk>
References: <20160123005828.GB5496@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160123005828.GB5496@birch.djwong.org>
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
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org, ebiggers3@gmail.com, xfs@oss.sgi.com

On Fri, Jan 22, 2016 at 04:58:28PM -0800, Darrick J. Wong wrote:
> If the program running dedupe receives a fatal signal during the
> dedupe loop, we should bail out to avoid tying up the system.

Applied.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
