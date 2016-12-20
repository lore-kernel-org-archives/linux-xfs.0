Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37056 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755385AbcLTK3i (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Tue, 20 Dec 2016 05:29:38 -0500
Received: from int-mx11.intmail.prod.int.phx2.redhat.com (int-mx11.intmail.prod.int.phx2.redhat.com [10.5.11.24])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4E241F44D7
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2016 10:29:38 +0000 (UTC)
Received: from eorzea.usersys.redhat.com (dhcp-27-38.brq.redhat.com [10.34.27.38])
        by int-mx11.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id uBKATZX2006731
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO)
        for <linux-xfs@vger.kernel.org>; Tue, 20 Dec 2016 05:29:37 -0500
Date: Tue, 20 Dec 2016 11:29:35 +0100
From: Carlos Maiolino <cmaiolino@redhat.com>
Subject: XFS_IOC_FSEMAP requirements
Message-ID: <20161220102935.ppt7ixjoh53uhu2e@eorzea.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org

Hi folks,

I've been working on the implementation of FSEMAP ioctl as we've been discussed
previously, and, the first discussion about this, was about using the same
fiemap structures to retrieve free extents from the btrees.

By our last chat about it (it's been a while, I know, I got busy with more
important stuff :), Dave suggested another uses for FSEMAP that were not in my
mind, so, I think it deserves its own implementation, independent of fiemap from
where the same idea came from.

So, I'd like to know, what else might FSEMAP be used for, beyond iterating free
space extents, so I can think of a new struct to be exchanged between user<->
kernel. FSEMAP is supposed to complement GETFSMAPX, discussed in LSF this year,
but I don't know if is there any plan to keep with GETFSMAPX or not, or even if
FSEMAP is still a valuable idea :)

Any comments, suggestions about to what direction should FSEMAP go?

Cheers
-- 
Carlos
