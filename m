Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:43778 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751155AbdKTPEu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Nov 2017 10:04:50 -0500
Received: by mail-wm0-f47.google.com with SMTP id x63so19434469wmf.2
        for <linux-xfs@vger.kernel.org>; Mon, 20 Nov 2017 07:04:49 -0800 (PST)
Date: Mon, 20 Nov 2017 16:04:46 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: Re: [RFC PATCH] xfs: Properly retry failed dquot items in case of
 error during buffer writeback
Message-ID: <20171120150446.33sftuqo7iwyjkk7@odin.localdomain>
References: <20170825120752.22553-1-cmaiolino@redhat.com>
 <20170825170400.GS4796@magnolia>
 <20170825215701.GT4796@magnolia>
 <20170828092030.l5z2hruccr7ctvl3@hades.localdomain>
 <e982d98b-973d-1679-9236-57cee47aff07@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e982d98b-973d-1679-9236-57cee47aff07@huawei.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Hou Tao <houtao1@huawei.com>
Cc: "Darrick J. Wong" <darrick.wong@oracle.com>, linux-xfs@vger.kernel.org

Hi,
> > 
> > I still don't have a xfstests to cover it, I couldn't reproduce the problem with
> > dquots yet, I'll focus more on this soon.
> I had written an xfstest case for the umount hang problem which is caused by the
> writeback of the dquota update, and it can be reproduced reliably. If you don't mind,
> i will clean it up and post to xfstest maillist this week.
> 

Same thing, I missed this e-mail.

If you haven't already, go for it, I'll test my patch against it too.

Cheers


-- 
Carlos
