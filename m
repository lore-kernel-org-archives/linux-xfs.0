Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 10 Dec 2007 14:20:27 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with ESMTP id lBAMK5U2018101
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2007 14:20:08 -0800
Received: from pentafluge.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 64E5EB24B48
	for <xfs@oss.sgi.com>; Mon, 10 Dec 2007 14:02:17 -0800 (PST)
Received: from pentafluge.infradead.org (pentafluge.infradead.org [213.146.154.40]) by cuda.sgi.com with ESMTP id LwaN1nTpRez42lo4 for <xfs@oss.sgi.com>; Mon, 10 Dec 2007 14:02:17 -0800 (PST)
Date: Mon, 10 Dec 2007 20:48:20 +0000
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: DMAPI problem with the new filldir implementation
Message-ID: <20071210204820.GA27456@infradead.org>
References: <475879DB.40705@sgi.com> <20071207002922.GQ115527101@sgi.com> <20071207014940.GS115527101@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071207014940.GS115527101@sgi.com>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Vlad Apostolov <vapo@sgi.com>, Christoph Hellwig <hch@infradead.org>, Mark Goodwin <markgw@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>


Looks good to me.  Might be worth to add a test that does a readdir
with a small buffer where only "." fits so we don't regress that special
case.
