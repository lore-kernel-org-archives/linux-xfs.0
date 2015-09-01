Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 60A067F5E
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 12:24:41 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 4382D8F8035
	for <xfs@oss.sgi.com>; Tue,  1 Sep 2015 10:24:38 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id QBbwh3X5J0WfZfy1 (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 01 Sep 2015 10:24:36 -0700 (PDT)
Date: Tue, 1 Sep 2015 10:24:34 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2] xfsprogs: add nftw64 translation for OS X
Message-ID: <20150901172434.GB14759@infradead.org>
References: <20150831185944.GI349@infradead.org>
	<1441094672-18368-1-git-send-email-jtulak@redhat.com>
	<20150901163120.GA10397@birch.djwong.org>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150901163120.GA10397@birch.djwong.org>
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
Cc: hch@infradead.org, xfs@oss.sgi.com, Jan Tulak <jtulak@redhat.com>

On Tue, Sep 01, 2015 at 09:31:20AM -0700, Darrick J. Wong wrote:
> Sorry for chiming in late, but there's only one caller of nftw64 and several
> callers of nftw; why not just change it to use nftw?

That sounds even better.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
