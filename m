Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id A7DC07FA4
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 06:18:14 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 86FDB8F804B
	for <xfs@oss.sgi.com>; Tue,  4 Aug 2015 04:18:14 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id HMAIoFecdySRiUdJ (version=TLSv1 cipher=AES128-SHA
	bits=128 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 04 Aug 2015 04:18:13 -0700 (PDT)
Date: Tue, 4 Aug 2015 04:18:12 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v4 04/11] xfsprogs: Add ifdef dirent checks where it was
	missing
Message-ID: <20150804111812.GD18906@infradead.org>
References: <1438612789-17486-5-git-send-email-jtulak@redhat.com>
	<1438680314-23950-1-git-send-email-jtulak@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1438680314-23950-1-git-send-email-jtulak@redhat.com>
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
To: Jan Tulak <jtulak@redhat.com>
Cc: hch@infradead.org, xfs@oss.sgi.com

On Tue, Aug 04, 2015 at 11:25:14AM +0200, Jan Tulak wrote:
> Add check for _DIRENT_HAVED_RECLEN/_OFF to read_directory().
> In dump_dirent() these checks already are used, but they were
> missing in read_directory.

Needs to be fixed to avoid > 80 char lines.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
