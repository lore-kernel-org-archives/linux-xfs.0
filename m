Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33880 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933242AbdGTJwB (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Thu, 20 Jul 2017 05:52:01 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 6E10B13A60
        for <linux-xfs@vger.kernel.org>; Thu, 20 Jul 2017 09:52:01 +0000 (UTC)
From: Jan Tulak <jtulak@redhat.com>
Subject: [PATCH 0/5] mkfs: use user values saved in opts table
Date: Thu, 20 Jul 2017 11:51:51 +0200
Message-Id: <20170720095156.35417-1-jtulak@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: linux-xfs@vger.kernel.org
Cc: Jan Tulak <jtulak@redhat.com>

The previous set (mkfs: save user input into opts table) added infrastructure,
which we are going to use now. I split it into two patchsets, because this
part is more ugly, so if there is an issue with this part, it doesn't stop
the other patches from merging.

The only thing this set is doing is that it replaces various ad-hoc variables
with set/get functions. As a result, we now have just a single place for these
values to be.  Once all the values are in a single place, we can expand the
automated validation and use it e.g.  for loading up optional config file like
Luis wants to do.

I'm not removing all variables, because for now, we need e.g. flags which are
not in the opts table. This is something that can happen later on, but for now,
I'm just replacing variables that can be done 1:1.

Description of all commits is updated.

Jan Tulak (5):
  mkfs: replace variables with opts table: -b,d,s options
  mkfs: replace variables with opts table: -i options
  mkfs: replace variables with opts table: -l options
  mkfs: replace variables with opts table: -n options
  mkfs: replace variables with opts table: -r options

 mkfs/xfs_mkfs.c | 1219 ++++++++++++++++++++++++++++++++-----------------------
 1 file changed, 718 insertions(+), 501 deletions(-)

-- 
2.11.0

