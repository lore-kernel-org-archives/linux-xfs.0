Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 591AC7CBD
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 11:13:03 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 2BD1F8F8040
	for <xfs@oss.sgi.com>; Sun, 25 Sep 2016 09:13:00 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id A1uADh29I5wkxEUG (version=TLSv1.2
	cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 25 Sep 2016 09:12:58 -0700 (PDT)
Date: Sun, 25 Sep 2016 09:12:56 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] libxcmd: fix counting of xfs entries in fs_table_insert
Message-ID: <20160925161256.GA25791@infradead.org>
References: <1474798162-25960-1-git-send-email-eguan@redhat.com>
	<20160925143155.GB29268@infradead.org>
	<20160925145816.GD27776@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20160925145816.GD27776@eguan.usersys.redhat.com>
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
Cc: Christoph Hellwig <hch@infradead.org>, linux-xfs@vger.kernel.org, billodo@redhat.com, xfs@oss.sgi.com

On Sun, Sep 25, 2016 at 10:58:16PM +0800, Eryu Guan wrote:
> It's already part of xfs/244, I noticed this bug because xfs/244 kept
> running. I just put the minimum steps in commit log. So I think we're
> good :)

But only as part of xfs/244 which doesn't work for v5 file systems.
To have good coverage we should not rely on testing an old format.
That beeing said I can't see a good reason for why xfs/244 should not
be run for v5 file systems, so I'll look into that instead.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
