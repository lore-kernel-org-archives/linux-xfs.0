Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:19049 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754765AbdA0JXU (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 27 Jan 2017 04:23:20 -0500
Date: Fri, 27 Jan 2017 01:22:49 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH v5 0/9] xfstests: online scrub/repair support
Message-ID: <20170127092249.GF2584@birch.djwong.org>
References: <148498621936.17109.4249711513404036449.stgit@birch.djwong.org>
 <20170126050838.GN1859@eguan.usersys.redhat.com>
 <20170126064434.GD2584@birch.djwong.org>
 <20170126072638.GP1859@eguan.usersys.redhat.com>
 <20170126075323.GE2584@birch.djwong.org>
 <20170127014146.GQ1859@eguan.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170127014146.GQ1859@eguan.usersys.redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eryu Guan <eguan@redhat.com>
Cc: linux-xfs@vger.kernel.org, fstests@vger.kernel.org

On Fri, Jan 27, 2017 at 09:41:46AM +0800, Eryu Guan wrote:
> On Wed, Jan 25, 2017 at 11:53:23PM -0800, Darrick J. Wong wrote:
> 
> > > > Sure.  I will never enable them in any of the heavily used groups, so
> > > > that should be fine.  Though I do have a request -- the 13xx numbers are
> > > > set up so that if test (1300+x) fuzzes object X and tries to xfs_repair
> > > > it, then test (1340+x) fuzzes the same X but tries to xfs_scrub it.
> > > > Could you interweave them when you renumber the tests?
> > > 
> > > Perhaps that explains why there's no 1336-1340 :)
> > 
> > Yep.
> > 
> > > > 
> > > > e.g. 1302 -> 510, 1342 -> 511, 1303 -> 512, 1343 -> 513?
> > > > 
> > > > That'll help me to keep together the repair & scrub fuzz tests.
> > > 
> > > Sure, I'll renumber the tests and let you review first before pushing
> > > them to upstream.
> > 
> > Ok, thanks!  I really appreciate it!
> 
> This is what it's like after renumbering, I'm going to fold it to patch
> 9/9 if you think it's OK.
> 
> 
> Moved "xfs/1300" to "xfs/349"
> 
> Moved "xfs/1301" to "xfs/350".
> Moved "xfs/1302" to "xfs/352".
> Moved "xfs/1303" to "xfs/354".
> Moved "xfs/1304" to "xfs/356".
> Moved "xfs/1305" to "xfs/358".
> Moved "xfs/1306" to "xfs/360".
> Moved "xfs/1307" to "xfs/362".
> Moved "xfs/1308" to "xfs/364".
> Moved "xfs/1309" to "xfs/366".
> Moved "xfs/1310" to "xfs/368".
> Moved "xfs/1311" to "xfs/370".
> Moved "xfs/1312" to "xfs/372".
> Moved "xfs/1313" to "xfs/374".
> Moved "xfs/1314" to "xfs/376".
> Moved "xfs/1315" to "xfs/378".
> Moved "xfs/1316" to "xfs/380".
> Moved "xfs/1317" to "xfs/382".
> Moved "xfs/1318" to "xfs/384".
> Moved "xfs/1319" to "xfs/386".
> Moved "xfs/1320" to "xfs/388".
> Moved "xfs/1321" to "xfs/390".
> Moved "xfs/1322" to "xfs/392".
> Moved "xfs/1323" to "xfs/394".
> Moved "xfs/1324" to "xfs/396".
> Moved "xfs/1325" to "xfs/398".
> Moved "xfs/1326" to "xfs/400".
> Moved "xfs/1327" to "xfs/402".
> Moved "xfs/1328" to "xfs/404".
> Moved "xfs/1329" to "xfs/406".
> Moved "xfs/1330" to "xfs/408".
> Moved "xfs/1331" to "xfs/410".
> Moved "xfs/1332" to "xfs/412".
> Moved "xfs/1333" to "xfs/414".
> Moved "xfs/1334" to "xfs/416".
> Moved "xfs/1335" to "xfs/418".
> 
> Moved "xfs/1341" to "xfs/351".
> Moved "xfs/1342" to "xfs/353".
> Moved "xfs/1343" to "xfs/355".
> Moved "xfs/1344" to "xfs/357".
> Moved "xfs/1345" to "xfs/359".
> Moved "xfs/1346" to "xfs/361".
> Moved "xfs/1347" to "xfs/363".
> Moved "xfs/1348" to "xfs/365".
> Moved "xfs/1349" to "xfs/367".
> Moved "xfs/1350" to "xfs/369".
> Moved "xfs/1351" to "xfs/371".
> Moved "xfs/1352" to "xfs/373".
> Moved "xfs/1353" to "xfs/375".
> Moved "xfs/1354" to "xfs/377".
> Moved "xfs/1355" to "xfs/379".
> Moved "xfs/1356" to "xfs/381".
> Moved "xfs/1357" to "xfs/383".
> Moved "xfs/1358" to "xfs/385".
> Moved "xfs/1359" to "xfs/387".
> Moved "xfs/1360" to "xfs/389".
> Moved "xfs/1361" to "xfs/391".
> Moved "xfs/1362" to "xfs/393".
> Moved "xfs/1363" to "xfs/395".
> Moved "xfs/1364" to "xfs/397".
> Moved "xfs/1365" to "xfs/399".
> Moved "xfs/1366" to "xfs/401".
> Moved "xfs/1367" to "xfs/403".
> Moved "xfs/1368" to "xfs/405".
> Moved "xfs/1369" to "xfs/407".
> Moved "xfs/1370" to "xfs/409".
> Moved "xfs/1371" to "xfs/411".
> Moved "xfs/1372" to "xfs/413".
> Moved "xfs/1373" to "xfs/415".
> Moved "xfs/1374" to "xfs/417".

Looks fine, thanks!

--D

> 
> Thanks,
> Eryu
