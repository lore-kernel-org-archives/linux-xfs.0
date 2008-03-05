Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Mar 2008 23:12:41 -0800 (PST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m257CK5D024448
	for <xfs@oss.sgi.com>; Tue, 4 Mar 2008 23:12:23 -0800
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60318653F98
	for <xfs@oss.sgi.com>; Tue,  4 Mar 2008 23:12:46 -0800 (PST)
Received: from bombadil.infradead.org (bombadil.infradead.org [18.85.46.34]) by cuda.sgi.com with ESMTP id aFVShyKH1HKUAi2h for <xfs@oss.sgi.com>; Tue, 04 Mar 2008 23:12:46 -0800 (PST)
Date: Wed, 5 Mar 2008 02:12:42 -0500
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: corruption in xfs_end_bio_unwritten
Message-ID: <20080305071242.GA30439@infradead.org>
References: <629727.55106.qm@web32504.mail.mud.yahoo.com> <47CDCA12.5060107@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47CDCA12.5060107@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Ravi Wijayaratne <ravi_wija@yahoo.com>, xfs@oss.sgi.com

On Tue, Mar 04, 2008 at 04:15:46PM -0600, Eric Sandeen wrote:
> Ravi Wijayaratne wrote:
> > Hi all,
> > 
> > I am seeing data corruption in xfs_end_bio_unwritten. Possibly the corruption is happening before.
> > Here is what I see.
> 
> what kernel, for starters?

Yeah, VOP_BMAP doesn't sound like anything recent ;-)
