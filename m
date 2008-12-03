Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB31ataF002988 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 19:36:55 -0600
Received: from estes.americas.sgi.com (estes.americas.sgi.com [128.162.236.10])
	by relay1.corp.sgi.com (Postfix) with ESMTP id AF6E98F8064
	for <xfs@oss.sgi.com>; Tue,  2 Dec 2008 17:36:54 -0800 (PST)
Date: Tue, 2 Dec 2008 19:42:25 -0600
From: "Bill O'Donnell" <billodo@sgi.com>
Subject: Re: [PATCH 9/9] Replace log checksumming code with CRCs.
Message-ID: <20081203014225.GE16811@sgi.com>
References: <20080925225650.GJ9822@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20080925225650.GJ9822@lst.de>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@lst.de>
Cc: xfs@sgi.com

On Fri, Sep 26, 2008 at 12:56:50AM +0200, Christoph Hellwig wrote:
| From: Dave Chinner <dgc@sgi.com>
| 
| The log has debug only checksum validation; replace this with
| stronger CRCs and always use it.
| 
| So far we only checksum the payload in every log buffer.  For the final
| version this needs to be extended to include the headers, too.
| 
| 
| [hch: minor adaptions]

looks good.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
