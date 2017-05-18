Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:52775 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933279AbdERRxi (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 18 May 2017 13:53:38 -0400
Date: Thu, 18 May 2017 19:53:29 +0200
From: Julian Wollrath <jwollrath@web.de>
Subject: Re: v4.12-rc1 does not compile: xfs_file_iomap_begin/end undefined
 reference
Message-ID: <20170518195329.44b9656a@saldaea>
In-Reply-To: <20170518172701.GB4519@birch.djwong.org>
References: <20170518191605.33635584@saldaea>
        <20170518172701.GB4519@birch.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-xfs@vger.kernel.org

Hi Darrick,

Am Thu, 18 May 2017 10:27:01 -0700
schrieb "Darrick J. Wong" <darrick.wong@oracle.com>:

> On Thu, May 18, 2017 at 07:16:05PM +0200, Julian Wollrath wrote:
> > Hi,
> > 
> > v4.12-rc1 does not compile with the attached config. I get the
> > following:
> > fs/built-in.o: In function `xfs_file_iomap_end':
> > xfs_iomap.c:(.text+0xb7f75): undefined reference to `put_dax'
> > fs/built-in.o: In function `xfs_file_iomap_begin':
> > xfs_iomap.c:(.text+0xb8802): undefined reference to
> > `dax_get_by_host  
> 
> Does the patch referenced in
> https://marc.info/?l=linux-xfs&m=149493347832378&w=2
> fix this too?

yes, that patch fixes it too. Thank you.

Cheers,
Julian

-- 
 ()  ascii ribbon campaign - against html e-mail 
 /\                        - against proprietary attachments
