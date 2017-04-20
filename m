Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:38513 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S947906AbdDTWMp (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 20 Apr 2017 18:12:45 -0400
Date: Thu, 20 Apr 2017 15:12:41 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: inconsistent lock state in kernel 4.11 rc6
Message-ID: <20170420221241.GH5205@birch.djwong.org>
References: <CABXGCsOUaRMg8ztgeqgN_BbQvPtaSxmyKJZ6hqMnKhO1VA4vmg@mail.gmail.com>
 <20170413200009.GZ8502@birch.djwong.org>
 <CABXGCsMzKE_dVGqf_NnARnkyHR8iGXSiVAek4FsEmFs4-TuDEw@mail.gmail.com>
 <CABXGCsMD_k7exKP0sUSm6oeDPWWouxzOrqY9R=_oc5v4wxtW8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABXGCsMD_k7exKP0sUSm6oeDPWWouxzOrqY9R=_oc5v4wxtW8A@mail.gmail.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: =?utf-8?B?0JzQuNGF0LDQuNC7INCT0LDQstGA0LjQu9C+0LI=?= <mikhail.v.gavrilov@gmail.com>
Cc: linux-xfs@vger.kernel.org

On Thu, Apr 20, 2017 at 09:28:58AM +0500, Михаил Гаврилов wrote:
> On 17 April 2017 at 22:18, Михаил Гаврилов <mikhail.v.gavrilov@gmail.com> wrote:
> > In which mainline kernel version would be merged patch "xfs: drop
> > iolock from reclaim context to appease lockdep" ?
> 
> 
> Today I updated kernel to rc7 and see that patch still not merged
> (messages with "inconsistent lock state" was returned)

It's not a critical bug fix, so please look for it in 4.12-rc1.

--D

> 
> 
> 
> --
> Best Regards,
> Mike Gavrilov.
