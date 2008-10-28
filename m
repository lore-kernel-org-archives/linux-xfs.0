Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 28 Oct 2008 00:52:41 -0700 (PDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.168.29])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9S7qWC0004113
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:52:34 -0700
Received: from ninsei.hu (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 1DD34550802
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:52:30 -0700 (PDT)
Received: from ninsei.hu (ninsei.hu [212.92.23.158]) by cuda.sgi.com with ESMTP id wqRfFiKDgsY6MPsi for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 00:52:30 -0700 (PDT)
Received: from kyra (lns-bzn-35-82-250-224-246.adsl.proxad.net [82.250.224.246])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by chatsubo.ninsei.hu (Postfix) with ESMTP id C92617833
	for <xfs@oss.sgi.com>; Tue, 28 Oct 2008 08:52:25 +0100 (CET)
Date: Tue, 28 Oct 2008 08:52:31 +0100
From: KELEMEN Peter <Peter.Kelemen@cern.ch>
Subject: Re: Map a disk LBA to filename?
Message-ID: <20081028075231.GA21181@kyra>
References: <4905A3FB.6080709@aei.mpg.de> <20081027114945.GE4985@disturbed> <4905B48A.8010108@aei.mpg.de> <4905BC13.3030402@drutsystem.com> <20081027233516.GG4985@disturbed> <4906BB32.8080403@aei.mpg.de> <20081028072105.GW4985@disturbed> <4906C164.6090704@aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4906C164.6090704@aei.mpg.de>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com

* Carsten Aulbert (carsten.aulbert@aei.mpg.de) [20081028 08:38]:

> # xfs_bmap -l /local/MCP/root/root.tar.bz2
> /local/MCP/root/root.tar.bz2:
>         0: [0..7]: 847868600..847868607 8 blocks

> But somehow this does not work out since 847868600>118212272.

xfs_bmap(8) talks in basic blocks (512 bytes).
847868600*512 < 118212272*4096.

HTH,
Peter

-- 
    .+'''+.         .+'''+.         .+'''+.         .+'''+.         .+''
 Kelemen Péter     /       \       /       \     Peter.Kelemen@cern.ch
.+'         `+...+'         `+...+'         `+...+'         `+...+'
