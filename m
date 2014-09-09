Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id A58487F57
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 17:29:58 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 93F17304032
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 15:29:55 -0700 (PDT)
Received: from bombadil.infradead.org ([198.137.202.9]) by cuda.sgi.com with
	ESMTP id 0vFOSuAmbNYwFtyM (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 15:29:54 -0700 (PDT)
Date: Tue, 9 Sep 2014 15:29:53 -0700
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 2/5] xfs_repair: preserve error state in
	process_shortform_attr
Message-ID: <20140909222953.GB27349@infradead.org>
References: <1410108065-18156-1-git-send-email-sandeen@redhat.com>
	<1410108065-18156-3-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1410108065-18156-3-git-send-email-sandeen@redhat.com>
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
To: Eric Sandeen <sandeen@redhat.com>
Cc: xfs@oss.sgi.com

On Sun, Sep 07, 2014 at 11:41:02AM -0500, Eric Sandeen wrote:
> process_shortform_attr uses the "junkit" error to
> track whether an error was found, but by assigning
> it directly to the result of valuecheck, previous
> errors are ignored, leading to unrepairable errors
> of the form i.e.
> 
> "entry has INCOMPLETE flag on in shortform attribute"
> or
> "entry contains illegal character in shortform attribute name"
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
