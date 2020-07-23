Return-Path: <SRS0=I6cU=BC=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D724C433DF
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 12:17:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 414902086A
	for <linux-xfs@archiver.kernel.org>; Thu, 23 Jul 2020 12:17:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="GZEfk+xV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727828AbgGWMRE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:17:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbgGWMRE (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Thu, 23 Jul 2020 08:17:04 -0400
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B489C0619DC
        for <linux-xfs@vger.kernel.org>; Thu, 23 Jul 2020 05:17:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=wBHPyCvZpCrOVHqNCeF+ihsLfbkjoBPYOH0hGQojUMA=; b=GZEfk+xVG0BKGe+zSi/GzpsWCc
        KWvNrOsTQXmR9S9EpuWjKU3uJUCWr9W0nvKE1EAneEso44RLEfB3HGPH5OGRlQTa7a30bfGxKU6Dt
        izJpBBeH9Z6q7TM+TySGVENQDUBtGA2BRhYzjsLiz/DiGZlymrWiPfl6VyRzINK96ts+gR/7KKYrF
        GupRTAxV/OQ8eYV808D4ZLVjafQQ6yzUrp8A7KrMyuCokcX5zzwjj71ZmlBe8HZQ+SXw7rcYc8gb1
        1W/pxV7gMZ6E5bkzhSgSDxceAf6byi63+S/EvTubO5mIm83Deje3lpsEwqhCteguWJT7gg6K2dUSo
        QtSBcZuA==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1jya9O-0001FQ-Us; Thu, 23 Jul 2020 12:16:39 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Adrian Bunk <bunk@debian.org>
CC:     fingerforce-devel@lists.alioth.debian.org, wvermin@gmail.com,
        roam@debian.org, pkg-acpi-devel@lists.alioth.debian.org,
        bdale@gag.com, team+postgresql@tracker.debian.org,
        debian-science-maintainers@lists.alioth.debian.org,
        erik@debian.org, debian.axhn@manchmal.in-ulm.de,
        linux-xfs@vger.kernel.org, debian-x@lists.debian.org,
        bigon@debian.org, fabo@debian.org, kkamagui@gmail.com,
        ssm@debian.org, mquinson@debian.org,
        debian-science-maintainers@lists.alioth.debian.org,
        debian-cinnamon@lists.debian.org,
        pkg-games-devel@lists.alioth.debian.org,
        pkg-opt-media-team@lists.alioth.debian.org,
        team+pkg-security@tracker.debian.org,
        pkg-java-maintainers@lists.alioth.debian.org, steinm@debian.org,
        edd@debian.org, stapelberg@debian.org,
        pkg-uwsgi-devel@lists.alioth.debian.org,
        pkg-voip-maintainers@lists.alioth.debian.org,
        debian-printing@lists.debian.org,
        debichem-devel@lists.alioth.debian.org,
        debian-ha-maintainers@lists.alioth.debian.org,
        pkg-gnome-maintainers@lists.alioth.debian.org, dirson@debian.org,
        debian-bugs-closed@lists.debian.org, eriberto@debian.org,
        r-pkg-team@alioth-lists.debian.net, holger@debian.org,
        paravoid@debian.org, chromium@packages.debian.org,
        pkg-electronics-devel@lists.alioth.debian.org,
        debian-med-packaging@lists.alioth.debian.org, fenio@debian.org,
        pkg-deepin-devel@lists.alioth.debian.org, jbernard@debian.org,
        debian-bugs-forwarded@lists.debian.org, vagrant@debian.org,
        debian-multimedia@lists.debian.org,
        Pkg-games-devel@alioth-lists.debian.net,
        debian-qt-kde@lists.debian.org, team+kylin@tracker.debian.org,
        gfa@zumbi.com.ar, anibal@debian.org,
        pkg-gnupg-maint@lists.alioth.debian.org,
        debian-hams@lists.debian.org
Subject: Processed (with 3 errors): gcc 10 FTBFS bugs housekeeping
Message-ID: <handler.s.C.159550620832558.transcript@bugs.debian.org>
References: <20200723120957.GA9498@localhost>
X-Debian-PR-Package: src:ngircd src:qtscript-opensource-src src:ust
 src:intel-gpu-tools src:i3-wm src:trinity src:ga src:xorg-server
 src:netdiscover src:gnushogi src:libqb src:t4kcommon src:mdocml
 src:r-bioc-preprocesscore src:racon src:chromium src:u-boot src:gmsh
 src:bibutils src:kamailio src:horizon-eda src:libcgns src:lepton-eda
 src:r-cran-mda src:acpitail src:ax25-tools src:nfdump src:clucene-core
 src:tuxmath src:altos src:ukui-control-center src:audit src:afflib dtkwm
 src:libacpi libbioparser-dev src:simgrid src:scalpel src:swt4-gtk
 src:kakoune src:gnupg2 src:ptouch-driver src:potrace src:freedroidrpg
 src:xfsprogs src:xsnow src:file-roller src:uwsgi src:rampler src:dtkwm
 src:nemo-python src:robustbase src:simutrans src:pgpool2 src:ax25-apps
 src:libsrtp2 src:dvdisaster src:kma src:sniffit src:r-cran-mclust
 src:hitch src:xserver-xorg-video-intel src:xawtv src:cpio src:fprintd
 src:intel-media-driver src:ipe src:gts src:evolution-rss src:nemo
 src:radsecproxy src:gretl src:tucnak src:janus src:hexer
X-Debian-PR-Source: acpitail afflib altos audit ax25-apps ax25-tools
 bibutils chromium clucene-core cpio dtkwm dvdisaster evolution-rss
 file-roller fprintd freedroidrpg ga gmsh gnupg2 gnushogi gretl gts hexer
 hitch horizon-eda i3-wm intel-gpu-tools intel-media-driver ipe janus
 kakoune kamailio kma lepton-eda libacpi libbioparser-dev libcgns libqb
 libsrtp2 mdocml nemo nemo-python netdiscover nfdump ngircd pgpool2 potrace
 ptouch-driver qtscript-opensource-src r-bioc-preprocesscore r-cran-mclust
 r-cran-mda racon radsecproxy rampler robustbase scalpel simgrid simutrans
 sniffit swt4-gtk t4kcommon trinity tucnak tuxmath u-boot ukui-control-center
 ust uwsgi xawtv xfsprogs xorg-server xserver-xorg-video-intel xsnow
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Thu, 23 Jul 2020 12:16:38 +0000
Sender: linux-xfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> reassign 956979 src:libacpi
Bug #956979 [src:acpitail] acpitail: ftbfs with GCC-10
Bug reassigned from package 'src:acpitail' to 'src:libacpi'.
No longer marked as found in versions acpitail/0.1-4.
Ignoring request to alter fixed versions of bug #956979 to the same values =
previously set
> unarchive 957422
Bug #957422 {Done: Seunghun Han <kkamagui@gmail.com>} [src:libacpi] libacpi=
: ftbfs with GCC-10
Unarchived Bug 957422
> forcemerge 957422 956979
Bug #957422 {Done: Seunghun Han <kkamagui@gmail.com>} [src:libacpi] libacpi=
: ftbfs with GCC-10
Bug #956979 [src:libacpi] acpitail: ftbfs with GCC-10
Severity set to 'normal' from 'serious'
Marked Bug as done
Owner recorded as Seunghun Han <kkamagui@gmail.com>.
Marked as fixed in versions libacpi/0.2-7.
Marked as found in versions libacpi/0.2-5.
Merged 956979 957422
> affects 957422 libacpi-dev src:acpitail
Bug #957422 {Done: Seunghun Han <kkamagui@gmail.com>} [src:libacpi] libacpi=
: ftbfs with GCC-10
Bug #956979 {Done: Seunghun Han <kkamagui@gmail.com>} [src:libacpi] acpitai=
l: ftbfs with GCC-10
Added indication that 957422 affects libacpi-dev and src:acpitail
Added indication that 956979 affects libacpi-dev and src:acpitail
> close 956984
Bug #956984 [src:afflib] afflib: ftbfs with GCC-10
Marked Bug as done
> close 956993 1.9.4-1
Bug #956993 [src:altos] altos: ftbfs with GCC-10
Marked as fixed in versions altos/1.9.4-1.
Bug #956993 [src:altos] altos: ftbfs with GCC-10
Marked Bug as done
> tags 957020 experimental
Bug #957020 [src:audit] audit: ftbfs with GCC-10
Added tag(s) experimental.
> close 957025 0.0.8-rc5+git20190411+0ff1383-1
Bug #957025 [src:ax25-apps] ax25-apps: ftbfs with GCC-10
Marked as fixed in versions ax25-apps/0.0.8-rc5+git20190411+0ff1383-1.
Bug #957025 [src:ax25-apps] ax25-apps: ftbfs with GCC-10
Marked Bug as done
> close 957026 0.0.10-rc5+git20190411+3595f87-1
Bug #957026 [src:ax25-tools] ax25-tools: ftbfs with GCC-10
Marked as fixed in versions ax25-tools/0.0.10-rc5+git20190411+3595f87-1.
Bug #957026 [src:ax25-tools] ax25-tools: ftbfs with GCC-10
Marked Bug as done
> close 957036 6.10-1
Bug #957036 {Done: merkys@debian.org} [src:bibutils] bibutils: ftbfs with G=
CC-10
Marked as fixed in versions bibutils/6.10-1.
Bug #957036 {Done: merkys@debian.org} [src:bibutils] bibutils: ftbfs with G=
CC-10
Bug 957036 is already marked as done; not doing anything.
> close 957090 83.0.4103.116-3
Bug #957090 [src:chromium] chromium: ftbfs with GCC-10
Marked as fixed in versions chromium/83.0.4103.116-3.
Bug #957090 [src:chromium] chromium: ftbfs with GCC-10
Marked Bug as done
> close 957093
Bug #957093 [src:clucene-core] clucene-core: ftbfs with GCC-10
Marked Bug as done
> forcemerge 963304 957103
Bug #963304 {Done: Anibal Monsalve Salazar <anibal@debian.org>} [src:cpio] =
cpio: FTBFS: i686-w64-mingw32-ld: ../gnu/libgnu.a(progname.o):progname.c:(.=
bss+0x0): multiple definition of `program_name'; global.o:global.c:(.bss+0x=
d8): first defined here
Bug #957103 [src:cpio] cpio: ftbfs with GCC-10
Marked Bug as done
Marked as fixed in versions cpio/2.13+dfsg-3.
Added tag(s) ftbfs.
Merged 957103 963304
> unarchive 952661
Bug #952661 {Done: Boyuan Yang <byang@debian.org>} [dtkwm] dtkwm: Update sy=
mbols files for optional template symbols going missing
Unarchived Bug 952661
> forcemerge 952661 957150
Bug #952661 {Done: Boyuan Yang <byang@debian.org>} [dtkwm] dtkwm: Update sy=
mbols files for optional template symbols going missing
Unable to merge bugs because:
package of #957150 is 'src:dtkwm' not 'dtkwm'
Failed to forcibly merge 952661: Did not alter merged bugs.

> tags 957156 experimental
Bug #957156 [src:dvdisaster] dvdisaster: ftbfs with GCC-10
Added tag(s) experimental.
> close 957182 0.3.96-1
Bug #957182 [src:evolution-rss] evolution-rss: ftbfs with GCC-10
Marked as fixed in versions evolution-rss/0.3.96-1.
Bug #957182 [src:evolution-rss] evolution-rss: ftbfs with GCC-10
Marked Bug as done
> close 957201 3.36.2-1
Bug #957201 [src:file-roller] file-roller: FTBFS with gcc-10: multiple defi=
nition of ForceDirectoryCreation
Marked as fixed in versions file-roller/3.36.2-1.
Bug #957201 [src:file-roller] file-roller: FTBFS with gcc-10: multiple defi=
nition of ForceDirectoryCreation
Marked Bug as done
> severity 957225 serious
Bug #957225 {Done: Laurent Bigonville <bigon@debian.org>} [src:fprintd] fpr=
intd: ftbfs with GCC-10
Severity set to 'serious' from 'normal'
> tags 957229 experimental
Bug #957229 [src:freedroidrpg] freedroidrpg: ftbfs with GCC-10
Added tag(s) experimental.
> close 957246 5.7.2-1
Bug #957246 [src:ga] ga: ftbfs with GCC-10
Marked as fixed in versions ga/5.7.2-1.
Bug #957246 [src:ga] ga: ftbfs with GCC-10
Marked Bug as done
> close 957280 4.6.0+ds1-1
Bug #957280 [src:gmsh] gmsh: ftbfs with GCC-10
Marked as fixed in versions gmsh/4.6.0+ds1-1.
Bug #957280 [src:gmsh] gmsh: ftbfs with GCC-10
Marked Bug as done
> close 957291 2.2.20-1
Bug #957291 [src:gnupg2] gnupg2: ftbfs with GCC-10
Marked as fixed in versions gnupg2/2.2.20-1.
Bug #957291 [src:gnupg2] gnupg2: ftbfs with GCC-10
Marked Bug as done
> fixed 957294 1.5~git20140725-2
Bug #957294 [src:gnushogi] gnushogi: ftbfs with GCC-10
Marked as fixed in versions gnushogi/1.5~git20140725-2.
> close 957306 2020b-1
Bug #957306 [src:gretl] gretl: ftbfs with GCC-10
Marked as fixed in versions gretl/2020b-1.
Bug #957306 [src:gretl] gretl: ftbfs with GCC-10
Marked Bug as done
> close 957323
Bug #957323 [src:gts] gts: ftbfs with GCC-10
Marked Bug as done
> close 957332 1.0.6-1
Bug #957332 [src:hexer] hexer: ftbfs with GCC-10
Marked as fixed in versions hexer/1.0.6-1.
Bug #957332 [src:hexer] hexer: ftbfs with GCC-10
Marked Bug as done
> close 957338 1.6.0-1
Bug #957338 [src:hitch] hitch: ftbfs with GCC-10
Marked as fixed in versions hitch/1.6.0-1.
Bug #957338 [src:hitch] hitch: ftbfs with GCC-10
Marked Bug as done
> close 957339 1.1.0-1
Bug #957339 [src:horizon-eda] horizon-eda: ftbfs with GCC-10
Marked as fixed in versions horizon-eda/1.1.0-1.
Bug #957339 [src:horizon-eda] horizon-eda: ftbfs with GCC-10
Marked Bug as done
> close 957349 4.18-1
Bug #957349 [src:i3-wm] i3-wm: ftbfs with GCC-10
Marked as fixed in versions i3-wm/4.18-1.
Bug #957349 [src:i3-wm] i3-wm: ftbfs with GCC-10
Marked Bug as done
> close 957363 1.25-1
Bug #957363 [src:intel-gpu-tools] intel-gpu-tools: ftbfs with GCC-10
The source 'intel-gpu-tools' and version '1.25-1' do not appear to match an=
y binary packages
Marked as fixed in versions intel-gpu-tools/1.25-1.
Bug #957363 [src:intel-gpu-tools] intel-gpu-tools: ftbfs with GCC-10
Marked Bug as done
> close 957362 20.2.0+dfsg1-1
Bug #957362 [src:intel-media-driver] intel-media-driver: ftbfs with GCC-10
Marked as fixed in versions intel-media-driver/20.2.0+dfsg1-1.
Bug #957362 [src:intel-media-driver] intel-media-driver: ftbfs with GCC-10
Marked Bug as done
> close 957367 7.2.17-1
Bug #957367 [src:ipe] ipe: ftbfs with GCC-10
Marked as fixed in versions ipe/7.2.17-1.
Bug #957367 [src:ipe] ipe: ftbfs with GCC-10
Marked Bug as done
> close 957386 0.10.3-1
Bug #957386 [src:janus] janus: ftbfs with GCC-10
Marked as fixed in versions janus/0.10.3-1.
Bug #957386 [src:janus] janus: ftbfs with GCC-10
Marked Bug as done
> close 957393 2020.01.16-1
Bug #957393 [src:kakoune] kakoune: ftbfs with GCC-10
Marked as fixed in versions kakoune/2020.01.16-1.
Bug #957393 [src:kakoune] kakoune: ftbfs with GCC-10
Marked Bug as done
> close 957395 5.3.5-1
Bug #957395 [src:kamailio] kamailio: ftbfs with GCC-10
Marked as fixed in versions kamailio/5.3.5-1.
Bug #957395 [src:kamailio] kamailio: ftbfs with GCC-10
Marked Bug as done
> close 957408 1.3.2-1
Bug #957408 [src:kma] kma: ftbfs with GCC-10
Marked as fixed in versions kma/1.3.2-1.
Bug #957408 [src:kma] kma: ftbfs with GCC-10
Marked Bug as done
> close 957419 1.9.11-1
Bug #957419 [src:lepton-eda] lepton-eda: ftbfs with GCC-10
Marked as fixed in versions lepton-eda/1.9.11-1.
Bug #957419 [src:lepton-eda] lepton-eda: ftbfs with GCC-10
Marked Bug as done
> tags 957432 experimental
Bug #957432 [src:libcgns] libcgns: ftbfs with GCC-10
Added tag(s) experimental.
> forcemerge 963363 957480
Bug #963363 [src:libsrtp2] libsrtp2: FTBFS: running cipher self-test for AE=
S-128 GCM using NSS...failed with error code 8
Bug #957480 [src:libsrtp2] libsrtp2: ftbfs with GCC-10
Marked as found in versions libsrtp2/2.3.0-4.
Added tag(s) ftbfs.
Bug #963363 [src:libsrtp2] libsrtp2: FTBFS: running cipher self-test for AE=
S-128 GCM using NSS...failed with error code 8
Marked as found in versions libsrtp2/2.3.0-2.
Merged 957480 963363
> retitle 957480 libsrtp2: FTBFS: running cipher self-test for AES-128 GCM =
using NSS...failed with error code 8
Bug #957480 [src:libsrtp2] libsrtp2: ftbfs with GCC-10
Bug #963363 [src:libsrtp2] libsrtp2: FTBFS: running cipher self-test for AE=
S-128 GCM using NSS...failed with error code 8
Changed Bug title to 'libsrtp2: FTBFS: running cipher self-test for AES-128=
 GCM using NSS...failed with error code 8' from 'libsrtp2: ftbfs with GCC-1=
0'.
Ignoring request to change the title of bug#963363 to the same title
> close 957469
Bug #957469 [src:libqb] libqb: ftbfs with GCC-10
Marked Bug as done
> forcemerge 963406 957527
Bug #963406 [src:mdocml] mdocml: FTBFS: make: echo: No such file or directo=
ry
Bug #957527 [src:mdocml] mdocml: ftbfs with GCC-10
Added tag(s) ftbfs.
Merged 957527 963406
> retitle 957527 mdocml: FTBFS: make: echo: No such file or directory
Bug #957527 [src:mdocml] mdocml: ftbfs with GCC-10
Bug #963406 [src:mdocml] mdocml: FTBFS: make: echo: No such file or directo=
ry
Changed Bug title to 'mdocml: FTBFS: make: echo: No such file or directory'=
 from 'mdocml: ftbfs with GCC-10'.
Ignoring request to change the title of bug#963406 to the same title
> close 957589 4.6.4-1
Bug #957589 [src:nemo] nemo: ftbfs with GCC-10
Marked as fixed in versions nemo/4.6.4-1.
Bug #957589 [src:nemo] nemo: ftbfs with GCC-10
Marked Bug as done
> close 957591 4.6.0-1
Bug #957591 [src:nemo-python] nemo-python: ftbfs with GCC-10
Marked as fixed in versions nemo-python/4.6.0-1.
Bug #957591 [src:nemo-python] nemo-python: ftbfs with GCC-10
Marked Bug as done
> close 957594
Bug #957594 [src:netdiscover] netdiscover: ftbfs with GCC-10
Marked Bug as done
> close 957606 1.6.20-1
Bug #957606 [src:nfdump] nfdump: ftbfs with GCC-10
Marked as fixed in versions nfdump/1.6.20-1.
Bug #957606 [src:nfdump] nfdump: ftbfs with GCC-10
Marked Bug as done
> close 957607 26-1
Bug #957607 [src:ngircd] ngircd: ftbfs with GCC-10
Marked as fixed in versions ngircd/26-1.
Bug #957607 [src:ngircd] ngircd: ftbfs with GCC-10
Marked Bug as done
> close 957678 4.1.2-1
Bug #957678 [src:pgpool2] pgpool2: ftbfs with GCC-10
Marked as fixed in versions pgpool2/4.1.2-1.
Bug #957678 [src:pgpool2] pgpool2: ftbfs with GCC-10
Marked Bug as done
> close 957703
Bug #957703 [src:potrace] potrace: ftbfs with GCC-10
Marked Bug as done
> close 957716 1.5.1-2
Bug #957716 [src:ptouch-driver] ptouch-driver: ftbfs with GCC-10
Marked as fixed in versions ptouch-driver/1.5.1-2.
Bug #957716 [src:ptouch-driver] ptouch-driver: ftbfs with GCC-10
Marked Bug as done
> close 957735 5.14.2+dfsg-1
Bug #957735 [src:qtscript-opensource-src] qtscript-opensource-src: ftbfs wi=
th GCC-10
Marked as fixed in versions qtscript-opensource-src/5.14.2+dfsg-1.
Bug #957735 [src:qtscript-opensource-src] qtscript-opensource-src: ftbfs wi=
th GCC-10
Marked Bug as done
> close 957745
Bug #957745 [src:radsecproxy] radsecproxy: ftbfs with GCC-10
Marked Bug as done
> unarchive 959465
Bug #959465 {Done: =3D?utf-8?q?=3DC3=3D89tienne_Mollier?=3D <etienne.mollie=
r@mailoo.org>} [libbioparser-dev] libbioparser-dev: Causes several packages=
 to FTBFS with Gcc 10
Unarchived Bug 959465
> reassign 957747 libbioparser-dev
Bug #957747 [src:racon] racon: ftbfs with GCC-10
Bug reassigned from package 'src:racon' to 'libbioparser-dev'.
No longer marked as found in versions racon/1.4.10-1.
Ignoring request to alter fixed versions of bug #957747 to the same values =
previously set
> reassign 957748 libbioparser-dev
Bug #957748 [src:rampler] rampler: ftbfs with GCC-10
Bug reassigned from package 'src:rampler' to 'libbioparser-dev'.
No longer marked as found in versions rampler/1.1.1-1.
Ignoring request to alter fixed versions of bug #957748 to the same values =
previously set
> forcemerge 959465 957747 957748
Bug #959465 {Done: =3D?utf-8?q?=3DC3=3D89tienne_Mollier?=3D <etienne.mollie=
r@mailoo.org>} [libbioparser-dev] libbioparser-dev: Causes several packages=
 to FTBFS with Gcc 10
Bug #959465 {Done: =3D?utf-8?q?=3DC3=3D89tienne_Mollier?=3D <etienne.mollie=
r@mailoo.org>} [libbioparser-dev] libbioparser-dev: Causes several packages=
 to FTBFS with Gcc 10
957747 was blocked by: 959465
957747 was not blocking any bugs.
Removed blocking bug(s) of 957747: 959465
957748 was blocked by: 959465
957748 was not blocking any bugs.
Removed blocking bug(s) of 957748: 959465
Added tag(s) sid and bullseye.
Bug #957747 [libbioparser-dev] racon: ftbfs with GCC-10
Set Bug forwarded-to-address to 'https://github.com/rvaser/bioparser/pull/7=
'.
Severity set to 'normal' from 'serious'
Failed to forcibly merge 959465: Failure while trying to adjust bugs, pleas=
e report this as a bug: Not altering archived bugs; see unarchive..
 at /usr/local/lib/site_perl/Debbugs/Control.pm line 2133.

> affects 959465 src:rampler src:racon
Failed to mark 959465 as affecting package(s): failed to get lock on /srv/b=
ugs.debian.org/spool/lock/959465 -- Unable to lock /srv/bugs.debian.org/spo=
ol/lock/959465 Resource temporarily unavailable.
Unable to lock /srv/bugs.debian.org/spool/lock/959465 Resource temporarily =
unavailable at /usr/local/lib/site_perl/Debbugs/Common.pm line 692.
Unable to lock /srv/bugs.debian.org/spool/lock/959465 Resource temporarily =
unavailable at /usr/local/lib/site_perl/Debbugs/Common.pm line 692.
Unable to lock /srv/bugs.debian.org/spool/lock/959465 Resource temporarily =
unavailable at /usr/local/lib/site_perl/Debbugs/Common.pm line 692.
Unable to lock /srv/bugs.debian.org/spool/lock/959465 Resource temporarily =
unavailable at /usr/local/lib/site_perl/Debbugs/Common.pm line 692.
Unable to lock /srv/bugs.debian.org/spool/lock/959465 Resource temporarily =
unavailable at /usr/local/lib/site_perl/Debbugs/Common.pm line 692.
Unable to lock /srv/bugs.debian.org/spool/lock/959465 Resource temporarily =
unavailable at /usr/local/lib/site_perl/Debbugs/Common.pm line 692.
Unable to lock /srv/bugs.debian.org/spool/lock/959465 Resource temporarily =
unavailable at /usr/local/lib/site_perl/Debbugs/Common.pm line 692.
Unable to lock /srv/bugs.debian.org/spool/lock/959465 Resource temporarily =
unavailable at /usr/local/lib/site_perl/Debbugs/Common.pm line 692.
Unable to lock /srv/bugs.debian.org/spool/lock/959465 Resource temporarily =
unavailable at /usr/local/lib/site_perl/Debbugs/Common.pm line 692.
 at /usr/local/lib/site_perl/Debbugs/Common.pm line 650.

> close 957736
Bug #957736 [src:r-bioc-preprocesscore] r-bioc-preprocesscore: ftbfs with G=
CC-10
Marked Bug as done
> close 957741
Bug #957741 [src:r-cran-mclust] r-cran-mclust: ftbfs with GCC-10
Marked Bug as done
> close 957743 0.5-1
Bug #957743 [src:r-cran-mda] r-cran-mda: ftbfs with GCC-10
Marked as fixed in versions r-cran-mda/0.5-1.
Bug #957743 [src:r-cran-mda] r-cran-mda: ftbfs with GCC-10
Marked Bug as done
> close 957765 0.93-6-1
Bug #957765 [src:robustbase] robustbase: ftbfs with GCC-10
Marked as fixed in versions robustbase/0.93-6-1.
Bug #957765 [src:robustbase] robustbase: ftbfs with GCC-10
Marked Bug as done
> close 957776
Bug #957776 [src:scalpel] scalpel: ftbfs with GCC-10
Marked Bug as done
> close 957796 3.25+dfsg-1
Bug #957796 [src:simgrid] simgrid: ftbfs with GCC-10
Marked as fixed in versions simgrid/3.25+dfsg-1.
Bug #957796 [src:simgrid] simgrid: ftbfs with GCC-10
Marked Bug as done
> close 957799 121.0-1
Bug #957799 [src:simutrans] simutrans: ftbfs with GCC-10
Marked as fixed in versions simutrans/121.0-1.
Bug #957799 [src:simutrans] simutrans: ftbfs with GCC-10
Marked Bug as done
> close 957819
Bug #957819 [src:sniffit] sniffit: ftbfs with GCC-10
Marked Bug as done
> close 957854 4.16.0-1
Bug #957854 [src:swt4-gtk] swt4-gtk: ftbfs with GCC-10
Marked as fixed in versions swt4-gtk/4.16.0-1.
Bug #957854 [src:swt4-gtk] swt4-gtk: ftbfs with GCC-10
Marked Bug as done
> close 957882 1.9+git20200331.4d2343bd18c7b-1
Bug #957882 [src:trinity] trinity: ftbfs with GCC-10
Marked as fixed in versions trinity/1.9+git20200331.4d2343bd18c7b-1.
Bug #957882 [src:trinity] trinity: ftbfs with GCC-10
Marked Bug as done
> close 957885 4.21-1
Bug #957885 [src:tucnak] tucnak: ftbfs with GCC-10
Marked as fixed in versions tucnak/4.21-1.
Bug #957885 [src:tucnak] tucnak: ftbfs with GCC-10
Marked Bug as done
> reassign 957888 src:t4kcommon
Bug #957888 [src:tuxmath] tuxmath: ftbfs with GCC-10
Bug reassigned from package 'src:tuxmath' to 'src:t4kcommon'.
No longer marked as found in versions tuxmath/2.0.3-5.
Ignoring request to alter fixed versions of bug #957888 to the same values =
previously set
> forcemerge 957859 957888
Bug #957859 [src:t4kcommon] t4kcommon: ftbfs with GCC-10
Bug #957888 [src:t4kcommon] tuxmath: ftbfs with GCC-10
Marked as found in versions t4kcommon/0.1.1-7.
Merged 957859 957888
> affects 957859 libt4k-common0-dev src:tuxmath
Bug #957859 [src:t4kcommon] t4kcommon: ftbfs with GCC-10
Bug #957888 [src:t4kcommon] tuxmath: ftbfs with GCC-10
Added indication that 957859 affects libt4k-common0-dev and src:tuxmath
Added indication that 957888 affects libt4k-common0-dev and src:tuxmath
> close 957889
Bug #957889 [src:u-boot] u-boot: ftbfs with GCC-10
Marked Bug as done
> close 957897 2.0.5-1
Bug #957897 [src:ukui-control-center] ukui-control-center: ftbfs with GCC-10
Marked as fixed in versions ukui-control-center/2.0.5-1.
Bug #957897 [src:ukui-control-center] ukui-control-center: ftbfs with GCC-10
Marked Bug as done
> close 957899
Bug #957899 [src:ust] ust: ftbfs with GCC-10
Marked Bug as done
> close 957907 2.0.19.1-1
Bug #957907 [src:uwsgi] uwsgi: ftbfs with GCC-10
Marked as fixed in versions uwsgi/2.0.19.1-1.
Bug #957907 [src:uwsgi] uwsgi: ftbfs with GCC-10
Marked Bug as done
> close 957967 3.107-1
Bug #957967 [src:xawtv] xawtv: ftbfs with GCC-10
Marked as fixed in versions xawtv/3.107-1.
Bug #957967 [src:xawtv] xawtv: ftbfs with GCC-10
Marked Bug as done
> close 957980 5.6.0-1
Bug #957980 [src:xfsprogs] xfsprogs: ftbfs with GCC-10
Marked as fixed in versions xfsprogs/5.6.0-1.
Bug #957980 [src:xfsprogs] xfsprogs: ftbfs with GCC-10
Marked Bug as done
> close 957993 2:1.20.8-1
Bug #957993 [src:xorg-server] xorg-server: ftbfs with GCC-10
Marked as fixed in versions xorg-server/2:1.20.8-1.
Bug #957993 [src:xorg-server] xorg-server: ftbfs with GCC-10
Marked Bug as done
> close 958002 2:2.99.917+git20200714-1
Bug #958002 [src:xserver-xorg-video-intel] xserver-xorg-video-intel: ftbfs =
with GCC-10
Marked as fixed in versions xserver-xorg-video-intel/2:2.99.917+git20200714=
-1.
Bug #958002 [src:xserver-xorg-video-intel] xserver-xorg-video-intel: ftbfs =
with GCC-10
Marked Bug as done
> close 958001 1:2.0.19-1
Bug #958001 [src:xsnow] xsnow: ftbfs with GCC-10
Marked as fixed in versions xsnow/1:2.0.19-1.
Bug #958001 [src:xsnow] xsnow: ftbfs with GCC-10
Marked Bug as done
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
952661: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D952661
956979: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D956979
956984: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D956984
956993: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D956993
957020: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957020
957025: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957025
957026: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957026
957036: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957036
957090: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957090
957093: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957093
957103: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957103
957150: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957150
957156: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957156
957182: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957182
957201: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957201
957225: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957225
957229: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957229
957246: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957246
957280: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957280
957291: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957291
957294: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957294
957306: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957306
957323: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957323
957332: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957332
957338: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957338
957339: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957339
957349: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957349
957362: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957362
957363: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957363
957367: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957367
957386: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957386
957393: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957393
957395: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957395
957408: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957408
957419: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957419
957422: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957422
957432: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957432
957469: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957469
957480: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957480
957527: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957527
957589: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957589
957591: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957591
957594: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957594
957606: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957606
957607: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957607
957678: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957678
957703: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957703
957716: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957716
957735: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957735
957736: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957736
957741: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957741
957743: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957743
957745: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957745
957747: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957747
957748: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957748
957765: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957765
957776: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957776
957796: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957796
957799: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957799
957819: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957819
957854: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957854
957859: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957859
957882: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957882
957885: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957885
957888: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957888
957889: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957889
957897: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957897
957899: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957899
957907: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957907
957967: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957967
957980: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957980
957993: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D957993
958001: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D958001
958002: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D958002
959465: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D959465
963304: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D963304
963363: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D963363
963406: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D963406
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
