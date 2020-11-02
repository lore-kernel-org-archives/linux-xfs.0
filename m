Return-Path: <SRS0=AlMJ=EI=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E829C00A89
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 05:02:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7CD421D91
	for <linux-xfs@archiver.kernel.org>; Mon,  2 Nov 2020 05:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbgKBFCH convert rfc822-to-8bit (ORCPT
        <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 2 Nov 2020 00:02:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:59316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725208AbgKBFCH (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 2 Nov 2020 00:02:07 -0500
From:   bugzilla-daemon@bugzilla.kernel.org
To:     linux-xfs@vger.kernel.org
Subject: [Bug 209981] Unable to boot with kernel 5.10-r1
Date:   Mon, 02 Nov 2020 05:02:06 +0000
X-Bugzilla-Reason: None
X-Bugzilla-Type: changed
X-Bugzilla-Watch-Reason: AssignedTo filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Product: File System
X-Bugzilla-Component: XFS
X-Bugzilla-Version: 2.5
X-Bugzilla-Keywords: 
X-Bugzilla-Severity: high
X-Bugzilla-Who: aaron.zakhrov@gmail.com
X-Bugzilla-Status: NEW
X-Bugzilla-Resolution: 
X-Bugzilla-Priority: P1
X-Bugzilla-Assigned-To: filesystem_xfs@kernel-bugs.kernel.org
X-Bugzilla-Flags: 
X-Bugzilla-Changed-Fields: 
Message-ID: <bug-209981-201763-tzBjyBEau6@https.bugzilla.kernel.org/>
In-Reply-To: <bug-209981-201763@https.bugzilla.kernel.org/>
References: <bug-209981-201763@https.bugzilla.kernel.org/>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Bugzilla-URL: https://bugzilla.kernel.org/
Auto-Submitted: auto-generated
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=209981

--- Comment #4 from Aaron Dominick (aaron.zakhrov@gmail.com) ---
(In reply to Eric Sandeen from comment #2)
> Why do you feel this is an xfs bug?  I don't see any indication of xfs
> problems in your logs.

I dont think the logs are being captured. Basically after I boot and enter my
lvm password, the system locks up with a bunch of pending in flight requests.
Among them are the xfs_buf_ioend_work



480.364103) pug : cpus nodee flags=8x0 nice act live-2/256 refont-3 pend Ing:
dbs_Mork_handler, URstat shepherd

180.3641031

480.3641031

480.3641031

workqueue events_unbound: flags-x2 puq 32: cpus=0-15 flags-ex4 nice 6 active
1/512 refcnt-6

480.3641031 in-flight: 84:fsnotify connector destroy world
funotify_connector_destroy_um 480.3611031 workqueue events_freezable: flags=0x1
I 488.364103) puj 6: cpus 3 node-0 flags-Ox0 nice-e active=1/256 refcnt-2

180.3641031

pending: pci_pme_1ist_scan

I 180.3641031 workqueue rcu gp: flags ex8

pug 6: cpu node-0 flags-ex0 nice-e active=1/256 refent-2 488.3641031 pend ing:
process_srcu 480.3641031 workqueue percpu vg: flags-ex8

480.3641031

480.364103) puj 6: cpus-3 mode flags-exe nice act lue=2/256 refont-4

480.3641031 pending: umstat_update. Iru_add_drain_per_cpu BARC102) puq 0: cpus=
node0 flags Ox0 nice-0 active 1/256 refent-2 E 480.3641031 pending:
unstat_update E 180.3641031 workqueue ur iteback: flags-xta 480.3641031 pug 32:
cpus=0-15 flags-0x1 nice o active 1/256 refcnt-3

180.3641631

E180.364103) in-flight: 1582 :ub workin

480.364103) workqueue kdnf lush: flags-x8 pg 6: cpus 3 node-0 Flags x0 nice to
actlue-1/256 refcnt-2 [ 480.364163) pend ing: dn_ Mork And nod) 400.3641031
workqueue xfs-buf/dn1: flags Oxc

480.3641031

480.3641031

480.3641031

100.364183)

pag 6: cpus 3 node o flags Ox0 nice e act lue-1/1 regent 3 pending: xfs
buf_loend_Mork Exfs) delayed: xfs_buf_loend uork Exfs)

180.3641031 workqueue xfs-conan 1: flags-Oxc I 480.36A103) puq 14: cpus-7
node=0 flags-ex0 nice-e active=1/256 refent-2

I 180.3641031 in-flight: 1331 Exis_end_lo xfs 180.3641031 porqueue
xfs-cilddr-4: Flags Oxe

pug 32: cpus-0-15 flags-Ox1 nice- active=1/256 refent-1 in-Flight: B6:xlog
cil_push_vork Exfs) BARC 1593) I 180.3641031 workqueue xfs-eofblocks/dn-4:
flags-Oxe

180.3641e3)

I 100.364103)

400.364103) 180.3641031 pug 6: cpus=3 node-o flags Ox0 nice-e active 1/256
refent-2

pend ing: xfs_cofblocks_Morker Exfs) 180.S55570) worqueue xs- cdn-1: flagsx1
100.5666701

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
