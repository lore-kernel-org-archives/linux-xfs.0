Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:1350 "EHLO
        ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753906AbdCFVvl (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 6 Mar 2017 16:51:41 -0500
Date: Tue, 7 Mar 2017 08:51:12 +1100
From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfstests and (automated) workflow?
Message-ID: <20170306215112.GN17542@dastard>
References: <CACj3i72avXdkrQdfGnfeRpnOoPo+bcBMForczMt_dnK-ZXQbkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACj3i72avXdkrQdfGnfeRpnOoPo+bcBMForczMt_dnK-ZXQbkg@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Jan Tulak <jtulak@redhat.com>
Cc: linux-xfs@vger.kernel.org

On Mon, Mar 06, 2017 at 03:25:03PM +0100, Jan Tulak wrote:
> Hi guys,
> 
> II decided to streamline and automate some things for me with testing
> xfs, but as I worked on it, I realise that surely I'm not the first
> one to do that. So I would like to ask you, can you share your tips
> and tricks? :-)
> 
> What I began to work at is a small suite of scripts to deploy a docker
> container (could be changed for a VM) which compiles my local version
> of xfsprogs and xfstests, runs it, and if I specify multiple
> revisions, it does it for every of the revisions and then tells me
> which test results changed between the revisions. I know the
> comparison of failures between runs can be done with
> tools/compare-failures. It doesn't detect a change in "not run"
> though, which I would like to detect too.
> 
> Are you using anything like this you can share?

Ted's xfstests-bld does this sort of stuff, IIRC, using KVM:

https://git.kernel.org/cgit/fs/ext2/xfstests-bld.git/

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
