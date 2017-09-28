Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail02.adl2.internode.on.net ([150.101.137.139]:9505 "EHLO
        ipmail02.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751591AbdI1LHq (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 28 Sep 2017 07:07:46 -0400
Date: Thu, 28 Sep 2017 21:07:19 +1000
From: Dave Chinner <david@fromorbit.com>
Subject: Re: Rationale for hardware RAID 10 su, sw values in FAQ
Message-ID: <20170928110719.GJ10621@dastard>
References: <b8c45869-849f-5124-f74f-68da0f9f34d7@mcneill.gen.nz>
 <20170927004302.GB3666@dastard>
 <db821c38-1307-0681-ffc2-4400ffd8d27a@mcneill.gen.nz>
 <20170927043308.GC3666@dastard>
 <c7ade829-9385-c517-581b-8dc73def5693@mcneill.gen.nz>
 <20170928125310.5687097e@harpe.intellique.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20170928125310.5687097e@harpe.intellique.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Ewen McNeill <xfs@ewen.mcneill.gen.nz>, linux-xfs@vger.kernel.org

On Thu, Sep 28, 2017 at 12:53:10PM +0200, Emmanuel Florac wrote:
> Le Thu, 28 Sep 2017 12:36:39 +1300
> Ewen McNeill <xfs@ewen.mcneill.gen.nz> écrivait:
> 
> > I'm obviously not an expert in filesystem layout optimisation.  But I 
> > have many years sysadmin experience dealing with lots of types of 
> > storage, and can write a couple of pages of text on the "background" 
> > bits next time I have a free moment.  The more advanced tunables
> > could remain "todo" until there's time for the perfect version...
> > 
> 
> As you're at it, please mention the potential problems with 512e (512
> bytes blocks emulated) disks, which are the vast majority of shipped
> disks nowadays. Doing RAID with these can lead to all sort of trouble
> by worsening the read/modify/write problem.

That's not a filesystem problem, though. Answering questions like
"what is the optimal device sector size for RAID on some random
storage hardware" is quite a long way outside the scope the
filesystem configuration guidelines....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
