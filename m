Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 417A57F56
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 03:17:44 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2811C8F8037
	for <xfs@oss.sgi.com>; Sun, 13 Apr 2014 01:17:44 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HmSKDaBwGTphblqt (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Sun, 13 Apr 2014 01:17:39 -0700 (PDT)
Date: Sun, 13 Apr 2014 01:17:38 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] generic/237: fix filtering for expected failure
	message
Message-ID: <20140413081738.GA5331@infradead.org>
References: <1397343317-14669-1-git-send-email-tytso@mit.edu>
	<1397343317-14669-4-git-send-email-tytso@mit.edu>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1397343317-14669-4-git-send-email-tytso@mit.edu>
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
To: Theodore Ts'o <tytso@mit.edu>
Cc: Ext4 Developers List <linux-ext4@vger.kernel.org>, xfs@oss.sgi.com

On Sat, Apr 12, 2014 at 06:55:17PM -0400, Theodore Ts'o wrote:
> Newer kernels return EACCES instead of EPERM when modifying an acl
> fails.  Update the filtering to handle this.
> 
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>


I've not seen this yet.  What exact configuration do you use to get the
error?

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
