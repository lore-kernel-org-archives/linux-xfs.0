Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 1E8107F37
	for <xfs@oss.sgi.com>; Wed, 13 Jan 2016 01:55:44 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id F1DC9304053
	for <xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:55:43 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id cwDWbg7qce9kCUtU (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Tue, 12 Jan 2016 23:55:40 -0800 (PST)
Date: Tue, 12 Jan 2016 23:55:40 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 4/6] linux.h: Use off64_t instead of loff_t
Message-ID: <20160113075540.GE21939@infradead.org>
References: <cover.1452627740.git.felix.janda@posteo.de>
	<20160112200001.GE568@nyan>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160112200001.GE568@nyan>
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
To: Felix Janda <felix.janda@posteo.de>
Cc: xfs@oss.sgi.com

On Tue, Jan 12, 2016 at 09:00:01PM +0100, Felix Janda wrote:
> These are equivalent on glibc, while musl does not know loff_t.
> 
> In the long run, it would be preferable to enable transparent LFS so
> that off64_t could be replaced by off_t.
> 
> Signed-off-by: Felix Janda <felix.janda@posteo.de>

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
