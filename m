Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 02:38:44 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S9cQLd011166
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:38:27 -0700
Received: from ninsei.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8F098551024
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:38:23 -0700 (PDT)
Received: from ninsei.hu (ninsei.hu [212.92.23.158]) by cuda.sgi.com with ESMTP id lAzC5LmC0HdCxTHG for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 02:38:23 -0700 (PDT)
Received: from kyra (pb-d-128-141-133-196.cern.ch [128.141.133.196])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id 3FA86782E
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 10:38:20 +0100 (CET)
Date: Tue, 28 Oct 2008 10:38:27 +0100
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: Map a disk LBA to filename?
Message-ID: <20081028093827.GA12133@kyra>
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <20081027233516.GG4985@disturbed> <4906BB32.8080403@aei.mpg.de> <20081028072105.GW4985@disturbed> <4906C164.6090704@aei.mpg.de> <4906D80F.9050500@aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4906D80F.9050500@aei.mpg.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Carsten Aulbert (carsten.aulbert@aei.mpg.de) [20081028 10:14]:

> Is it possible that blocks != bsized_blocks?

xfs_bmap(8) talks in basic blocks (512 bytes).
660 div 8 = 82, so try:

	blockget -b 82 -n

> Sorry for these questions, but I'm quite lost and I have not
> been able to find the answer in the man pages.

The second paragraph of man xfs_bmap says:

“[...] All the file offsets and disk blocks are in units of
512-byte blocks, no matter what the filesystem’s block size
is.”

HTH,
Peter

-- 
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+''
 Kelemen Péter     /       \       /       \     Peter.Kelemen@cern.ch
.+'         `+...+'         `+...+'         `+...+'         `+...+'
