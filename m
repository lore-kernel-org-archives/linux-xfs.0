Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 20 Apr 2008 23:53:14 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with SMTP id m3L6qqod008674
	for <xfs@oss.sgi.com>; Sun, 20 Apr 2008 23:52:54 -0700
Message-ID: <480C39FD.7090703@sgi.com>
Date: Mon, 21 Apr 2008 16:53:49 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: PARTIAL TAKE 976035 - kill usesless IHOLD calls in xfs_rename
References: <20080421052419.E52E458C4C15@chook.melbourne.sgi.com> <20080421060836.GA31296@infradead.org>
In-Reply-To: <20080421060836.GA31296@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Christoph Hellwig <hch@infradead.org>
Cc: xfs@oss.sgi.com

Christoph Hellwig wrote:
> Any reason you didn't commit:
> 
>   [PATCH 1/2] kill parent == child checks in xfs_remove and xfs_rmdir
>   [PATCH 2/2] kill usesless IHOLD calls in xfs_remove and xfs_rmdir
> 
> in this round, it's pretty much the equivalent treatment to remove and
> rmdir that we did to rename in this and the previous patch.
> 

No intentional reason.  For some reason I didn't apply them when I tested
the last batch.  They're going through QA now and I'll check them in soon.
