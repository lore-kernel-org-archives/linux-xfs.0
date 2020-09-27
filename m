Return-Path: <SRS0=IMq7=DE=vger.kernel.org=linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED49C4346E
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 06:26:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0087423A04
	for <linux-xfs@archiver.kernel.org>; Sun, 27 Sep 2020 06:26:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgI0G0X (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Sun, 27 Sep 2020 02:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729125AbgI0G0X (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Sun, 27 Sep 2020 02:26:23 -0400
X-Greylist: delayed 1003 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 26 Sep 2020 23:26:23 PDT
Received: from buxtehude.debian.org (buxtehude.debian.org [IPv6:2607:f8f0:614:1::1274:39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02153C0613CE
        for <linux-xfs@vger.kernel.org>; Sat, 26 Sep 2020 23:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
        :CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
        Content-ID:Content-Description:In-Reply-To;
        bh=Yehaic510LTYiHAULbOqn/GLitvRoad5JgUrOi2yOFQ=; b=aKU+gxLg5S6o4riXDQzOpQk7lB
        IDAnZZhkFp4Fv9J77GzqE2+ooc8S7ti7M2z9Ng54POkdQxc5WvtR5whAaB2BFT7KOy4nWjAuuZ8B2
        /t7clId2pHOersNH7KAn/4/K8xbXttu7+ScZSFAR6ZLbOZTXCDIqkpYETKXbuzHzw+6Gdw8ldXtvY
        Cv8RFXLSLBXAdBfZw16ekcLk5BKFc7a7HHFTecGum4shD8449+d3si0nl9zcGEE4u6Wh2bnGTmNMZ
        fc7tKh2Fcohv3kmrD2+y+iD5Y5z2/lvOtvb/juM3HftkBxaK9lKpeE7KbfF0XlrHM0syW7EIy+i3D
        dM43lcGw==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.92)
        (envelope-from <debbugs@buxtehude.debian.org>)
        id 1kMPsC-0001D0-7P; Sun, 27 Sep 2020 06:09:24 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
From:   "Debian Bug Tracking System" <owner@bugs.debian.org>
To:     Helmut Grohne <helmut@subdivi.de>
CC:     stender@debian.org, debian-ocaml-maint@lists.debian.org,
        bernat@debian.org, costela@debian.org,
        pkg-ruby-extras-maintainers@lists.alioth.debian.org,
        debian-efi@lists.debian.org,
        debian-science-maintainers@lists.alioth.debian.org,
        debian-gcc@lists.debian.org,
        python-modules-team@lists.alioth.debian.org,
        pkg-haskell-maintainers@lists.alioth.debian.org,
        pkg-go-maintainers@lists.alioth.debian.org,
        pkg-vdr-dvb-devel@lists.alioth.debian.org, showard@debian.org,
        ubuntu-dev-team@lists.alioth.debian.org, vasek.gello@gmail.com,
        debian-multimedia@lists.debian.org, giuliopaci@gmail.com,
        federico@debian.org, sunweaver@debian.org,
        pkg-raspi-maintainers@lists.alioth.debian.org, nicolas@debian.org,
        zufus@debian.org, pkg-libvirt-maintainers@lists.alioth.debian.org,
        gcs@debian.org, jari.aalto@cante.net,
        python-apps-team@lists.alioth.debian.org, terpstra@debian.org,
        pkg-java-maintainers@lists.alioth.debian.org,
        debichem-devel@lists.alioth.debian.org,
        debian-astro-maintainers@lists.alioth.debian.org,
        debichem-devel@lists.alioth.debian.org, unit193@debian.org,
        pkg-php-pear@lists.alioth.debian.org,
        pkg-xen-devel@lists.alioth.debian.org, jose@calhariz.com,
        debian-med-packaging@lists.alioth.debian.org, helmut@subdivi.de,
        taffit@debian.org,
        debian-science-maintainers@lists.alioth.debian.org,
        linux-xfs@vger.kernel.org, team@neuro.debian.net,
        jrnieder@gmail.com, pkg-clamav-devel@lists.alioth.debian.org
Subject: Processed: tag ftbfs bugs
Message-ID: <handler.s.C.16011866472690.transcript@bugs.debian.org>
References: <20200927060346.GA19492@alf.mars>
X-Debian-PR-Package: src:ants src:msxpertsuite src:gnokii src:puma
 src:kodi src:python-biom-format src:gcc-4.9 src:xfsprogs src:gdebi
 src:openhft-chronicle-bytes src:weresync src:yi src:didjvu src:openhft-chronicle-network
 src:mlton src:phonetisaurus src:doc-linux-fr src:vdr-plugin-xineliboutput
 src:yamcha src:libgnatcoll-db src:socat src:openhft-chronicle-wire src:edb
 src:consul src:xorp src:barrier src:xen src:python-django-push-notifications
 src:fftw3 src:clamav src:datanommer.consumer src:mingw-ocaml
 src:vdirsyncer src:rpi.gpio src:coq-float src:symfony src:libvirt-sandbox
 src:critterding src:golang-github-golang-geo src:ruby-graffiti
 src:ssh-askpass-fullscreen src:mpqc src:aac-tactics src:davs2
 src:pluto-find-orb src:gcc-cross-support src:arduino src:openhft-chronicle-threads
 src:jinja2-time src:pesign src:tootle src:xz-utils src:zypper
X-Debian-PR-Source: aac-tactics ants arduino barrier clamav consul
 coq-float critterding datanommer.consumer davs2 didjvu doc-linux-fr edb
 fftw3 gcc-4.9 gcc-cross-support gdebi gnokii golang-github-golang-geo
 jinja2-time kodi libgnatcoll-db libvirt-sandbox mingw-ocaml mlton mpqc
 msxpertsuite openhft-chronicle-bytes openhft-chronicle-network
 openhft-chronicle-threads openhft-chronicle-wire pesign phonetisaurus
 pluto-find-orb puma python-biom-format python-django-push-notifications
 rpi.gpio ruby-graffiti socat ssh-askpass-fullscreen symfony tootle
 vdirsyncer vdr-plugin-xineliboutput weresync xen xfsprogs xorp xz-utils
 yamcha yi zypper
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date:   Sun, 27 Sep 2020 06:09:24 +0000
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

Processing commands for control@bugs.debian.org:

> tags 769218 + ftbfs
Bug #769218 [src:gcc-4.9] gcc-4.9: FTBFS in jessie: Error! CRCs do not matc=
h! Got 264aca47, expected 95962ba4
Added tag(s) ftbfs.
> tags 828550 + ftbfs
Bug #828550 [src:socat] socat: FTBFS with openssl 1.1.0
Added tag(s) ftbfs.
> tags 832330 + ftbfs
Bug #832330 [src:gnokii] gnokii: FTBFS in experimental: undefined reference=
s to GUI_HideAbout, CloseLogosWindow
Added tag(s) ftbfs.
> tags 838137 + ftbfs
Bug #838137 [src:critterding] critterding: FTBFS in experimental: be_comman=
d_system.cpp:13:94: error: '_1' was not declared in this scope
Added tag(s) ftbfs.
> tags 844795 + ftbfs
Bug #844795 [src:datanommer.consumer] datanommer.consumer: FTBFS: build-dep=
endency not installable: python-datanommer.models
Added tag(s) ftbfs.
> tags 875386 + ftbfs
Bug #875386 [src:phonetisaurus] phonetisaurus: FTBFS: error: 'EncodeTable' =
does not name a type
Added tag(s) ftbfs.
> tags 876230 + ftbfs
Bug #876230 [src:ssh-askpass-fullscreen] ssh-askpass-fullscreen: FTBFS: und=
efined reference to symbol 'XUngrabServer'
Added tag(s) ftbfs.
> tags 876238 + ftbfs
Bug #876238 [src:gcc-cross-support] gcc-cross-support: FTBFS, wants to rege=
nerate debian/control with more and renamed packages
Added tag(s) ftbfs.
> tags 876495 + ftbfs
Bug #876495 [src:arduino] arduino: FTBFS  error: <anonymous processing.app.=
zeroconf.jmdns.ArduinoDNSTaskStarter$1> is not abstract and does not overri=
de abstract method startResponder(DNSIncoming,InetAddress,int) in DNSTaskSt=
arter
Added tag(s) ftbfs.
> tags 877319 + ftbfs
Bug #877319 [src:golang-github-golang-geo] golang-github-golang-geo: FTBFS =
on i386
Added tag(s) ftbfs.
> tags 884018 + ftbfs
Bug #884018 [src:yamcha] yamcha: FTBFS with debhelper >=3D 10.9.2: dh_syste=
md_enable is no longer used in compat >=3D 11, please use dh_installsystemd=
 instead
Added tag(s) ftbfs.
> tags 884710 + ftbfs
Bug #884710 [src:ants] ants: FTBFS: URL using bad/illegal format or missing=
 URL
Added tag(s) ftbfs.
> tags 890716 + ftbfs
Bug #890716 [src:xfsprogs] xfsprogs: FTBFS with glibc 2.27: error: conflict=
ing types for 'copy_file_range'
Added tag(s) ftbfs.
> tags 904010 + ftbfs
Bug #904010 [src:edb] edb: FTBFS in sid (build-depends on emacs24)
Added tag(s) ftbfs.
> tags 910813 + ftbfs
Bug #910813 [src:doc-linux-fr] doc-linux-fr: FTBFS, latex error "Package in=
putenc Error: Invalid UTF-8 byte sequence"
Added tag(s) ftbfs.
> tags 917677 + ftbfs
Bug #917677 [src:python-django-push-notifications] python-django-push-notif=
ications: FTBFS: dh_auto_test: pybuild --test -i python{version} -p 3.7 --s=
ystem=3Dcustom "--test-args=3D{interpreter} tests/runtests.py" returned exi=
t code 13
Added tag(s) ftbfs.
> tags 917699 + ftbfs
Bug #917699 [src:mlton] urweb: FTBFS: build-dependency not installable: mlt=
on
Bug #904475 [src:mlton] mlton: build-depends on the version of itself that =
is going to be built
Added tag(s) ftbfs.
Added tag(s) ftbfs.
> tags 917729 + ftbfs
Bug #917729 [src:weresync] weresync: FTBFS: dpkg-buildpackage: error: dpkg-=
source -b . subprocess returned exit status 2
Added tag(s) ftbfs.
> tags 919084 + ftbfs
Bug #919084 [src:davs2] davs2: FTBFS everywhere
Added tag(s) ftbfs.
> tags 920481 + ftbfs
Bug #920481 [src:openhft-chronicle-wire] openhft-chronicle-wire: FTBFS: use=
s deprecated classes/methods
Added tag(s) ftbfs.
> tags 921218 + ftbfs
Bug #921218 [src:pluto-find-orb] pluto-find-orb: FTBFS with mpc_func.h:55:5=
: error: conflicting declaration of 'int create_mpc_packed_desig(char*, con=
st char*)' with 'C' linkage
Added tag(s) ftbfs.
> tags 924774 + ftbfs
Bug #924774 [src:openhft-chronicle-network] openhft-chronicle-network: FTBF=
S: cannot find symbol
Added tag(s) ftbfs.
> tags 924816 + ftbfs
Bug #924816 [src:mingw-ocaml] mingw-ocaml: FTBFS: hasgot.c:(.text+0x13): un=
defined reference to `tgetent'
Added tag(s) ftbfs.
> tags 924843 + ftbfs
Bug #924843 [src:msxpertsuite] msxpertsuite: FTBFS: MassSpectrum.cpp:50:10:=
 fatal error: pwiz/data/msdata/MSDataFile.hpp: No such file or directory
Added tag(s) ftbfs.
> tags 924970 + ftbfs
Bug #924970 [src:openhft-chronicle-threads] openhft-chronicle-threads: FTBF=
S: package net.openhft.chronicle.core.threads does not exist
Added tag(s) ftbfs.
> tags 925523 + ftbfs
Bug #925523 [src:openhft-chronicle-bytes] openhft-chronicle-bytes: FTBFS pa=
ckage net.openhft.chronicle.core.cleaner does not exist
Added tag(s) ftbfs.
> tags 929713 + ftbfs
Bug #929713 [src:openhft-chronicle-bytes] openhft-chronicle-bytes: FTBFS: [=
ERROR] /<<PKGBUILDDIR>>/src/main/java/net/openhft/chronicle/bytes/NativeByt=
esStore.java:[78,48] cannot find symbol
Added tag(s) ftbfs.
> tags 939940 + ftbfs
Bug #939940 [src:libvirt-sandbox] libvirt-sandbox: missing python build-dep=
endency causes FTBFS with gtk-doc-tools 1.32
Added tag(s) ftbfs.
> tags 943396 + ftbfs
Bug #943396 [src:fftw3] FTBFS on armhf: testsuite segfault
Added tag(s) ftbfs.
> tags 943695 + ftbfs
Bug #943695 [src:didjvu] didjvu: FTBFS: ERROR: tests.test_timestamp.test_ti=
mezones
Added tag(s) ftbfs.
> tags 944030 + ftbfs
Bug #944030 [src:jinja2-time] jinja2-time: FTBFS in unstable
Added tag(s) ftbfs.
> tags 945961 + ftbfs
Bug #945961 [src:xz-utils] xz-utils: FTBFS: cannot stat 'debian/tmp/usr/lib=
/x86_64-linux-gnu/liblzma.so.*'
Added tag(s) ftbfs.
> tags 947586 + ftbfs
Bug #947586 [src:xorp] FTBFS with scons 3.1.2-1
Added tag(s) ftbfs.
> tags 948645 + ftbfs
Bug #948645 [src:pesign] pesign FTBFS: nss-induced error: unsigned conversi=
on from =E2=80=98int=E2=80=99 to =E2=80=98unsigned char=E2=80=99 changes va=
lue from =E2=80=98496=E2=80=99 to =E2=80=98240=E2=80=99 [-Werror=3Doverflow]
Added tag(s) ftbfs.
> tags 950929 + ftbfs
Bug #950929 [src:python-biom-format] python-biom-format: FTBFS with pandas =
1.0: test failures
Added tag(s) ftbfs.
> tags 951921 + ftbfs
Bug #951921 [src:vdr-plugin-xineliboutput] vdr-plugin-xineliboutput: FTBFS:=
 xine_sxfe_frontend.c:1873: undefined reference to `glXQueryExtensionsStrin=
g'
Added tag(s) ftbfs.
> tags 951923 + ftbfs
Bug #951923 [src:gdebi] gdebi: FTBFS: test failures
Added tag(s) ftbfs.
> tags 951948 + ftbfs
Bug #951948 [src:vdirsyncer] vdirsyncer: FTBFS: LookupError: setuptools-scm=
 was unable to detect version for '/<<PKGBUILDDIR>>'.
Added tag(s) ftbfs.
> tags 951999 + ftbfs
Bug #951999 [src:mpqc] mpqc: FTBFS: messmpi.cc:203:21: error: call to 'MPI_=
Errhandler_set' declared with attribute error: MPI_Errhandler_set was remov=
ed in MPI-3.0. Use MPI_Comm_set_errhandler instead.
Added tag(s) ftbfs.
> tags 952016 + ftbfs
Bug #952016 [src:ruby-graffiti] ruby-graffiti: FTBFS: ERROR: Test "ruby2.7"=
 failed.
Added tag(s) ftbfs.
> tags 952099 + ftbfs
Bug #952099 [src:tootle] tootle: FTBFS: ../../src/Views/AbstractView.vala:2=
4.5-24.23: error: Creation method of abstract class cannot be public.
Added tag(s) ftbfs.
> tags 952431 + ftbfs
Bug #952431 [src:symfony] symfony: FTBFS: test failures with PHP 7.4
Added tag(s) ftbfs.
> tags 952741 + ftbfs
Bug #952741 [src:puma] [RFH] FTBFS: Tests sometimes get stuck and the build=
 gets forcefully terminated
Added tag(s) ftbfs.
> tags 960427 + ftbfs
Bug #960427 [src:zypper] zypper: FTBFS with boost 1.71
Added tag(s) ftbfs.
> tags 963853 + ftbfs
Bug #963853 [src:clamav] clamav: FTBFS on IPv6-only environments
Added tag(s) ftbfs.
> tags 964873 + ftbfs
Bug #964873 [src:consul] consul: FTBFS: src/github.com/hashicorp/consul/age=
nt/consul/server.go:467:29: cannot use s.logger (type *log.Logger) as type =
hclog.Logger in assignment
Added tag(s) ftbfs.
> tags 968276 + ftbfs
Bug #968276 [src:yi] yi: FTBFS in sid (missing deps)
Added tag(s) ftbfs.
> tags 968339 + ftbfs
Bug #968339 [src:kodi] kodi: FTBFS in sid (test failures)
Added tag(s) ftbfs.
> tags 968965 + ftbfs
Bug #968965 [src:xen] xen: FTBFS in sid
Added tag(s) ftbfs.
> tags 970453 + ftbfs
Bug #970453 [src:coq-float] coq-float: FTBFS in sid
Added tag(s) ftbfs.
> tags 970454 + ftbfs
Bug #970454 [src:aac-tactics] aac-tactics: FTBFS in sid
Added tag(s) ftbfs.
> tags 970611 + ftbfs
Bug #970611 [src:barrier] src:barrier: fails to migrate to testing for too =
long: FTBFS on mips*el
Added tag(s) ftbfs.
> tags 970726 + ftbfs
Bug #970726 [src:rpi.gpio] rpi.gpio: FTBFS in sid (gcc-10)
Added tag(s) ftbfs.
> tags 971018 + ftbfs
Bug #971018 [src:libgnatcoll-db] libgnatcoll-db: FTBFS on mips(64)el with a=
ssembler message: branch out of range
Added tag(s) ftbfs.
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
769218: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D769218
828550: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D828550
832330: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D832330
838137: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D838137
844795: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D844795
875386: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D875386
876230: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D876230
876238: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D876238
876495: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D876495
877319: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D877319
884018: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D884018
884710: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D884710
890716: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D890716
904010: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D904010
904475: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D904475
910813: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D910813
917677: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D917677
917699: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D917699
917729: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D917729
919084: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D919084
920481: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D920481
921218: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D921218
924774: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D924774
924816: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D924816
924843: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D924843
924970: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D924970
925523: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D925523
929713: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D929713
939940: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D939940
943396: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D943396
943695: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D943695
944030: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D944030
945961: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D945961
947586: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D947586
948645: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D948645
950929: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D950929
951921: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D951921
951923: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D951923
951948: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D951948
951999: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D951999
952016: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D952016
952099: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D952099
952431: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D952431
952741: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D952741
960427: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D960427
963853: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D963853
964873: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D964873
968276: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D968276
968339: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D968339
968965: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D968965
970453: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D970453
970454: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D970454
970611: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D970611
970726: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D970726
971018: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D971018
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
