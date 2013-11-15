Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A86177F83
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 08:09:35 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 7B1AA304039
	for <xfs@oss.sgi.com>; Fri, 15 Nov 2013 06:09:32 -0800 (PST)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 3JKUzDlKiDNnF3NT (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 15 Nov 2013 06:09:28 -0800 (PST)
Date: Fri, 15 Nov 2013 06:09:28 -0800
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] xfsprogs/quota: fix NULL pointer dereference in report_f
Message-ID: <20131115140928.GB17561@infradead.org>
References: <52849CC5.10109@oracle.com> <20131114140916.GA13501@infradead.org>
	<52857BEB.4010406@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <52857BEB.4010406@oracle.com>
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
To: Jeff Liu <jeff.liu@oracle.com>
Cc: Christoph Hellwig <hch@infradead.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On Fri, Nov 15, 2013 at 09:42:03AM +0800, Jeff Liu wrote:
> As per a rough tryout while fixing this problem, it seems that most of those
> functions are just not be invoked since other precheck-ups were failed before
> calling them.  We have another old fix for stat_f():

Most or all?  If this is the only case I'm fine with putting your
patch in a quick fix, even if I'd prefer the version I suggested for
the long run.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
