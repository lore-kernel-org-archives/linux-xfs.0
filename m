Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE2A3164BA
	for <linux-xfs@vger.kernel.org>; Sun, 25 Jan 2026 16:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769357481; cv=none; b=H57izekK3GfMHfKjXfsckKInBf4j9PVyOoXfcq+9VyDyQGfLAO3Ooug21nTwwYGHgAqRVVb5amqY7IlkOWTbBBgttywP72E5v9Egh8nEJzbDkCn92oojsVTyDNoPx5TRxkymyHbnRyegtR2jtiyZdsfyVdCX7cANhzCFVq8ImvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769357481; c=relaxed/simple;
	bh=zLt/Q6oconOBjy7jS3hZ8sOUxrN50oiFfOl1kxVC0o4=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=spxD7Iw1FKfWeFi+BuaNSV9E3nF88Qowj8ITGR7YK95dPgSJTcpv7ZY9VhotLmCVIZws1mDI+CVRyFxR4x7XetVqYjI1oUnTJDQMBqQlc78/Bz5EZDFcrnOnNmP2BVaZnw216cL2Rvkndf489PqIka5LSlz0/oEq5oBGOS8PAGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=PkavO7ym; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="PkavO7ym"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=zLt/Q6oconOBjy7jS3hZ8sOUxrN50oiFfOl1kxVC0o4=; b=PkavO7ym6bTkg2jG8VgiD5594D
	dszwxVGJiwdoqqEujSyrSn1CTgMS0SULfpkiMgOeUomgXYAPqLJTLsbAM9XcdvTSxMviWyxkVTX4m
	uh2YzF1lyFqll2GPiA9ARY89nyYsQvkkeag2QivHBpVVTH3rFfqPgm5Fs3cWVekXOLYs1sCoIQXDH
	zDDMeMizeSWCl9I1/laz4yigxGci73M1ENua9KD3fvkbugimS/tRgI9vgcW4u41nMZrx2FcGlw483
	y5iBcBnrqtFTn9JbJ5OPgSysR4D3w9QQeXsJAqtjPAk340lItDMlVTGsxybE29fIUPtWaB/Ap9/9W
	tuQXza0A==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1vk2g1-003ewF-22;
	Sun, 25 Jan 2026 16:09:25 +0000
X-Loop: owner@bugs.debian.org
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: MIME-tools 5.510 (Entity 5.510)
Content-Type: text/plain; charset=utf-8
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
To: Santiago Vila <sanvila@debian.org>
CC: bugs@hypra.fr, team+openstack@tracker.debian.org, christsc@gmx.de,
 pkg-owncloud-maintainers@lists.alioth.debian.org,
 debian-ai@lists.debian.org, jamessan@debian.org, f.b.brokken@rug.nl,
 pierre.neyron@free.fr, debian-med-packaging@lists.alioth.debian.org,
 maxy@debian.org, gpsbabel@packages.debian.org, debian-x@lists.debian.org,
 team+pkg-security@tracker.debian.org,
 pkg-deepin-devel@lists.alioth.debian.org, debian-remote@lists.debian.org,
 roehling@debian.org, team+pkg-go@tracker.debian.org, bage@debian.org,
 mmyangfl@gmail.com, pkg-freeradius-maintainers@lists.alioth.debian.org,
 pkg-javascript-devel@alioth-lists.debian.net,
 debian-astro-maintainers@lists.alioth.debian.org,
 pkg-electronics-devel@alioth-lists.debian.net,
 pkg-a11y-devel@alioth-lists.debian.net, bluca@debian.org, phil@hands.com,
 frankie@debian.org, gspr@nonempty.org,
 pkg-java-maintainers@lists.alioth.debian.org,
 pkg-lua-devel@lists.alioth.debian.org, serpent@debian.org,
 debian-tex-maint@lists.debian.org, andrewsh@debian.org,
 tom@cryptography.ch, scott@kitterman.com,
 pkg-rust-maintainers@alioth-lists.debian.net, bigon@debian.org,
 pkg-ruby-extras-maintainers@lists.alioth.debian.org,
 debian-input-method@lists.debian.org, team+tasktools@tracker.debian.org,
 debichem-devel@lists.alioth.debian.org,
 debian-ocaml-maint@lists.debian.org, bdale@gag.com, georgesk@debian.org,
 sten@debian.org, pkg-pascal-devel@lists.alioth.debian.org,
 mati75@linuxmint.pl, dr@jones.dk,
 pkg-request-tracker-maintainers@lists.alioth.debian.org,
 pkg-utopia-maintainers@lists.alioth.debian.org, lamby@debian.org,
 Debian-mobcom-maintainers@lists.alioth.debian.org, debian@helgefjell.de,
 glaubitz@physik.fu-berlin.de, pkg-samba-maint@lists.alioth.debian.org,
 jpakkane@gmail.com, pkg-perl-maintainers@lists.alioth.debian.org,
 pkg-libvirt-maintainers@lists.alioth.debian.org, roam@debian.org,
 marillat@debian.org, debian.tormod@gmail.com,
 debian-astro-maintainers@lists.alioth.debian.org, fsfs@debian.org,
 pkg-sdl-maintainers@lists.alioth.debian.org,
 team+clojure@tracker.debian.org, emc-developers@lists.sourceforge.net,
 agmartin@debian.org, pkg-matrix-maintainers@lists.alioth.debian.org,
 team+cryptocoin@tracker.debian.org, sthibault@debian.org,
 pkg-gnome-maintainers@lists.alioth.debian.org,
 pkg-javascript-devel@lists.alioth.debian.org, tchet@debian.org,
 francois@debian.org, pkg-php-pear@lists.alioth.debian.org,
 pmatthaei@debian.org, debian-ha-maintainers@lists.alioth.debian.org,
 debian-xml-sgml-pkgs@lists.alioth.debian.org,
 debian-lego-team@lists.alioth.debian.org, dkogan@debian.org,
 tommi.hoynalanmaa@iki.fi, guilhem@debian.org,
 team+salvage@tracker.debian.org,
 debian-astro-maintainers@alioth-lists.debian.net,
 pkg-games-devel@lists.alioth.debian.org, aerusso@aerusso.net,
 joodebian@joonet.de, vagrant@debian.org, team+lxde@tracker.debian.org,
 debian-astro-maintainers@lists.alioth.debian.org, valhalla@debian.org,
 iwamatsu@debian.org, debian-qt-kde@lists.debian.org, debian@jff.email,
 pcp@groups.io, team+math@tracker.debian.org, rousseau@debian.org,
 linux-xfs@vger.kernel.org, debian-emacsen@lists.debian.org,
 post@rolandgruber.de, bottoms@debian.org, fungi@yuggoth.org,
 team+python@tracker.debian.org, team+postgresql@tracker.debian.org,
 debian-science-maintainers@lists.alioth.debian.org,
 pkg-linaro-lava-devel@lists.alioth.debian.org, roland@debian.org,
 daniel@debian.org, tmancill@debian.org,
 pkg-xmpp-devel@lists.alioth.debian.org, bzed@debian.org, anibal@debian.org,
 pkg-electronics-devel@lists.alioth.debian.org,
 pkg-dpdk-devel@lists.alioth.debian.org, team+pkg-rpm@tracker.debian.org,
 vv221@debian.org, debian-science-maintainers@alioth-lists.debian.net,
 jcfp@debian.org, gabriel@debian.org, debian-multimedia@lists.debian.org,
 liferea@packages.debian.org, pkg-rakudo-devel@lists.alioth.debian.org,
 r-pkg-team@alioth-lists.debian.net,
 debian-pan-maintainers@alioth-lists.debian.net,
 pkg-freeipa-devel@alioth-lists.debian.net, camm@debian.org,
 atzlinux@sina.com, c.schoenert@t-online.de
Subject: Processed (with 8 errors): unarchive
Message-ID: <handler.s.C.1769357048868513.transcript@bugs.debian.org>
References: <aXY-9Gw2XbmGOC9x@nuc>
X-Debian-PR-Package: src:coq-interval src:python-pyghmi src:coq-equations
 src:gnuradio src:angband src:python-xvfbwrapper src:networking-l2gw
 src:coq-elpi src:python-oslo.limit src:python-skbio src:ovn src:mistral
 src:0ad src:sane-backends src:freeradius src:snakemake src:python-cloudkittyclient
 src:rocblas src:libssh src:python-xstatic-tv4 src:magnum-ui
 src:designate-tempest-plugin src:ibus-input-pad src:saods9 src:python-keystoneclient
 src:astap src:dicom3tools src:mathcomp-multinomials src:python-xstatic-angular-fileupload
 src:castle-game-engine src:passenger src:atool src:stimfit src:mpgrafic
 src:python-octavia-lib src:python-yappi src:python-openstacksdk
 src:python-aodhclient src:python-xstatic-angular-schema-form src:theme-d
 src:vulkan-loader src:gtk4 src:magnum src:dsh src:r-bioc-rhtslib src:typer
 src:log4cpp src:python-cursive src:reprof src:osmo-trx src:healpix-java
 src:python-reno src:python-pbr src:cinder-tempest-plugin src:partclone
 src:reproject src:placement src:masakari src:python-plaster-pastedeploy
 src:python-oslo.reports src:python-kafka src:python-os-refresh-config
 src:texmaker src:mistral-dashboard src:python-xstatic-angular-cookies
 src:numpy src:librcsb-core-wrapper src:re2c src:cloudkitty-dashboard
 src:deepin-icon-theme src:fastml src:linuxcnc src:yara src:obconf
 src:python-rfc3986 src:lua5.1 src:openqa src:python-mrcfile
 src:bash-completion src:tbox src:python-os-brick src:hypre src:supermin
 src:python-marathon src:cloc src:sentencepiece src:liferea src:python-xstatic-smart-table
 src:python-sphinx-feature-classification src:python-xstatic-dagre src:xfig
 src:python-os-win src:tinygltf src:nmodl src:python-watcherclient
 src:python-xstatic-jquery.bootstrap.wizard src:sfepy src:libpdb-redo
 src:python-octaviaclient src:python-oslo.db src:cif-tools src:igv
 src:xfsprogs src:texstudio src:python-vulndb src:python-xstatic-bootswatch
 src:ghmm src:python-pykmip src:artfastqgenerator src:coq-quickchick
 src:liblocale-gettext-perl src:tempest-horizon src:xmlsec1 src:python-searchlightclient
 src:virtualjaguar src:python-keystonemiddleware src:python-xstatic-roboto-fontface
 src:python-automaton src:psycopg3 src:pyspf src:python-validate-pyproject
 src:elektroid src:runc src:heat src:python-xstatic-jquery.quicksearch
 src:nfs4-acl-tools src:python-xstatic-js-yaml src:pirs src:cockpit
 src:python-os-testr src:m2l-pyqt src:olm src:python-ddt src:python-daemonize
 src:rabbitmq-server src:python-typepy src:python-xstatic-jasmine
 src:python-xstatic-jsencrypt src:dnsjit src:btrfs-progs src:gap-factint
 src:python-termstyle src:dosage src:python-xstatic-rickshaw
 src:python-manilaclient src:ccsm src:python-xstatic-angular-mock
 src:python-pybedtools src:vramsteg src:python-xstatic-moment-timezone
 src:pseudo src:magnum-tempest-plugin src:insighttoolkit5 src:apvlv
 src:python-wsme src:watcher-dashboard src:ironic-inspector src:reprepro
 src:mruby src:coffeescript src:weather-util src:python-json-pointer
 src:python-oslo.metrics src:python-xstatic-bootstrap-datepicker
 src:python-zunclient src:libqcow src:certmonger src:xscreensaver
 src:xraylarch src:python-oslo.context src:qtfeedback-opensource-src
 src:django-pipeline src:watcher src:belenios src:clonalframeml
 src:keystone-tempest-plugin src:manila-tempest-plugin src:ldap-account-manager
 src:python-oslo.cache src:enigma src:cinder src:notary src:notion
 src:ironic-tempest-plugin src:poezio src:dpdk src:python-ovsdbapp
 src:networking-bgpvpn src:python-pydotplus src:libsdl2-mixer src:bladerf
 src:meson src:pyftdi src:h5z-zfp src:coq-stdpp src:neutron-taas
 src:fastnetmon src:python-castellan src:python-jsonpath-rw src:lavacli
 src:pyliblo src:sixer src:open-vm-tools src:electrum src:python-debtcollector
 src:python-infinity src:gnome-pie src:python-yaql src:ssh-cron src:pyerfa
 src:python-morph src:python-os-resource-classes src:python-calmjs.parse
 src:ibus-table src:ivar src:watcher-tempest-plugin src:matplotlib
 src:biomaj3-process src:python-monasca-statsd src:abcmidi src:unicorn-engine
 src:r-cran-data.table src:mono src:libfiu src:zaqar src:python-os-traits
 src:fop src:python-glance-store src:python-xstatic-qunit src:clazy
 src:pyscard src:python-oslo.privsep src:python-xstatic-jquery src:silx
 src:python-wsaccel src:python-xstatic-lodash src:crmsh src:subversion
 src:r-bioc-rhdf5filters src:python-mbstrdecoder src:dssp src:tempest
 src:vitrage-dashboard src:python-seamicroclient src:emscripten
 src:macaulay2 src:python-xstatic-spin src:sphinxcontrib-pecanwsme
 src:dtkgui src:healpy src:netgen src:neutron-vpnaas-dashboard
 src:python-os-vif src:scipy src:python-django-appconf src:octavia-dashboard
 src:oscar src:gpsbabel src:python-oslotest src:ceilometer-instance-poller
 src:zaqar-ui src:python-xstatic-angular-lrdragndrop src:pymatgen
 src:python-xstatic-angular-ui-router src:coq src:ispell-fo src:python-dracclient
 src:pcp src:heat-dashboard src:python-sushy src:libervia-pubsub
 src:python-xstatic-hogan src:designate-dashboard src:python-sphinxcontrib.apidoc
 src:cysignals src:oar src:giac src:python-ldappool src:astrometry.net
 src:python-bashate src:dkimpy src:python-fisx src:python-hpilo src:glance
 src:xfe src:python-pymummer src:ocaml src:python-monascaclient
 src:python-oslo.vmware src:todoman src:timew src:python-numpysane
 src:rt-extension-jsgantt src:trove-dashboard src:libxeddsa src:networking-bagpipe
 src:librnd src:gubbins src:python-uritemplate src:python-zake
 src:gcc-h8300-hms src:octavia src:avldrums.lv2 src:photutils
 src:python-logutils src:macs src:python-xstatic-objectpath src:python-pyhcl
 src:petsc4py src:python-oslo.utils src:scikit-learn src:designate
 src:jellyfish1 src:findimagedupes src:python-oslo.service src:liblouis
 src:kxd src:eos-sdk src:os-autoinst src:python-requests-mock src:bzip3
 src:python-json-patch src:sphinxcontrib-programoutput src:qtbase-opensource-src-gles
 src:pyroute2 src:python-blazarclient src:python-dogpile.cache
 src:neutron-tempest-plugin src:gpicview src:python-xstatic-jquery-migrate
 src:python-wsgi-intercept src:python-ceilometermiddleware src:octavia-tempest-plugin
 src:python-xstatic-jquery.tablesorter src:sccache src:xdp-tools
 src:python-oslo.i18n src:python-memcache src:python-xstatic-angular-vis
 src:python-xstatic-dagre-d3 src:python-msgpack src:brian src:rust-ureq
 src:python-ironic-lib src:python-autobahn src:python-django-pyscss
 src:python-xstatic-font-awesome src:dita-ot src:python-hacking
 src:python-xstatic-magic-search src:glance-tempest-plugin src:heat-tempest-plugin
 src:neuron src:manila src:christianriesen-base32 src:python-fastbencode
 src:expeyes src:python-stestr src:python-os-service-types src:python-tosca-parser
 src:python-xstatic-json2yaml src:cloudkitty-tempest-plugin src:python-osprofiler
 src:python-pyspike src:tortoize src:python-xstatic-filesaver
 src:gnome-shell-extensions-extra src:python-rcssmin src:planets
 src:mypaint src:udm src:asymptote src:rocfft src:libsimpleini
 src:ring-clojure src:gtg-trace src:mistral-tempest-plugin src:libdnf
 src:libiio src:barbican-tempest-plugin src:bitshuffle src:python-cryptography
 src:python-os-client-config src:mrc src:sch-rnd src:bepasty
 src:raritan-json-rpc-sdk src:iraf-rvsao src:python-scciclient src:freeipa
 src:libtorrent-rasterbar src:pampi src:networking-baremetal
 src:python-xstatic-angular src:python-fixtures src:jupyterhub
 src:python-xstatic-graphlib src:zaqar-tempest-plugin src:python-designateclient
 src:rustc src:x2goclient src:python-tempestconf src:trove-tempest-plugin
 src:python-neutronclient src:retroarch src:dante src:networking-sfc
 src:python-hdf5plugin src:dnscap src:python-oslo.messaging src:typeshed
 src:python-oslo.rootwrap src:python-xstatic-moment src:python-troveclient
 src:pcb-rnd src:python-oslo.config src:python-pymemcache src:biomaj3-download
 src:cloudkitty src:bali-phy src:python-calmjs.types src:python-zaqarclient
 src:python-xstatic-angular-bootstrap src:linuxinfo src:neutron
 src:ironic-ui src:xxdiff src:rt-extension-mergeusers src:python-xstatic-term.js
 src:python-xstatic-bootstrap-scss src:rust-gping src:telemetry-tempest-plugin
 src:python-proliantutils src:masakari-monitors src:python-http-parser
 src:qrisk2 src:qtbase-opensource-src src:vitrage-tempest-plugin
 src:python-oslo.middleware src:statsmodels src:ironic src:mira
 src:python-osc-placement src:libpqxx src:python-neutron-lib
 src:python-magnumclient src:python-xstatic src:python-oslo.versionedobjects
 src:ssl-utils-clojure src:python-xstatic-mdi src:python-glanceclient
 src:openstack-trove src:python-masakariclient src:python-oslo.policy
 src:maxima src:python-xstatic-angular-gettext src:python-pycadf src:lcrq
 src:python-ironic-inspector-client src:scolasync src:libtommath
 src:python-tinyalign src:turing src:muse-el src:ocaml-benchmark
 src:python-barbicanclient src:ibus-m17n src:pyfuse3 src:nextcloud-desktop
 src:python-oslo.log src:samba src:dropbear src:icmake src:libfm src:sep
 src:as31 src:masakari-dashboard src:rime-cantonese src:python-xstatic-angular-uuid
 src:confget src:python-xstatic-jquery-ui
X-Debian-PR-Source: 0ad abcmidi angband apvlv artfastqgenerator as31 astap
 astrometry.net asymptote atool avldrums.lv2 bali-phy barbican-tempest-plugin
 bash-completion belenios bepasty biomaj3-download biomaj3-process
 bitshuffle bladerf brian btrfs-progs bzip3 castle-game-engine ccsm
 ceilometer-instance-poller certmonger christianriesen-base32 cif-tools
 cinder cinder-tempest-plugin clazy cloc clonalframeml cloudkitty
 cloudkitty-dashboard cloudkitty-tempest-plugin cockpit coffeescript
 confget coq coq-elpi coq-equations coq-interval coq-quickchick coq-stdpp
 crmsh cysignals dante deepin-icon-theme designate designate-dashboard
 designate-tempest-plugin dicom3tools dita-ot django-pipeline dkimpy dnscap
 dnsjit dosage dpdk dropbear dsh dssp dtkgui electrum elektroid emscripten
 enigma eos-sdk expeyes fastml fastnetmon findimagedupes fop freeipa
 freeradius gap-factint gcc-h8300-hms ghmm giac glance glance-tempest-plugin
 gnome-pie gnome-shell-extensions-extra gnuradio gpicview gpsbabel
 gtg-trace gtk4 gubbins h5z-zfp healpix-java healpy heat heat-dashboard
 heat-tempest-plugin hypre ibus-input-pad ibus-m17n ibus-table icmake igv
 insighttoolkit5 iraf-rvsao ironic ironic-inspector ironic-tempest-plugin
 ironic-ui ispell-fo ivar jellyfish1 jupyterhub keystone-tempest-plugin kxd
 lavacli lcrq ldap-account-manager libdnf libervia-pubsub libfiu libfm
 libiio liblocale-gettext-perl liblouis libpdb-redo libpqxx libqcow
 librcsb-core-wrapper librnd libsdl2-mixer libsimpleini libssh libtommath
 libtorrent-rasterbar libxeddsa liferea linuxcnc linuxinfo log4cpp lua5.1
 m2l-pyqt macaulay2 macs magnum magnum-tempest-plugin magnum-ui manila
 manila-tempest-plugin masakari masakari-dashboard masakari-monitors
 mathcomp-multinomials matplotlib maxima meson mira mistral mistral-dashboard
 mistral-tempest-plugin mono mpgrafic mrc mruby muse-el mypaint netgen
 networking-bagpipe networking-baremetal networking-bgpvpn networking-l2gw
 networking-sfc neuron neutron neutron-taas neutron-tempest-plugin
 neutron-vpnaas-dashboard nextcloud-desktop nfs4-acl-tools nmodl notary
 notion numpy oar obconf ocaml ocaml-benchmark octavia octavia-dashboard
 octavia-tempest-plugin olm open-vm-tools openqa openstack-trove
 os-autoinst oscar osmo-trx ovn pampi partclone passenger pcb-rnd pcp
 petsc4py photutils pirs placement planets poezio pseudo psycopg3 pyerfa
 pyftdi pyfuse3 pyliblo pymatgen pyroute2 pyscard pyspf python-aodhclient
 python-autobahn python-automaton python-barbicanclient python-bashate
 python-blazarclient python-calmjs.parse python-calmjs.types
 python-castellan python-ceilometermiddleware python-cloudkittyclient
 python-cryptography python-cursive python-daemonize python-ddt
 python-debtcollector python-designateclient python-django-appconf
 python-django-pyscss python-dogpile.cache python-dracclient
 python-fastbencode python-fisx python-fixtures python-glance-store
 python-glanceclient python-hacking python-hdf5plugin python-hpilo
 python-http-parser python-infinity python-ironic-inspector-client
 python-ironic-lib python-json-patch python-json-pointer python-jsonpath-rw
 python-kafka python-keystoneclient python-keystonemiddleware
 python-ldappool python-logutils python-magnumclient python-manilaclient
 python-marathon python-masakariclient python-mbstrdecoder python-memcache
 python-monasca-statsd python-monascaclient python-morph python-mrcfile
 python-msgpack python-neutron-lib python-neutronclient python-numpysane
 python-octavia-lib python-octaviaclient python-openstacksdk
 python-os-brick python-os-client-config python-os-refresh-config
 python-os-resource-classes python-os-service-types python-os-testr
 python-os-traits python-os-vif python-os-win python-osc-placement
 python-oslo.cache python-oslo.config python-oslo.context python-oslo.db
 python-oslo.i18n python-oslo.limit python-oslo.log python-oslo.messaging
 python-oslo.metrics python-oslo.middleware python-oslo.policy
 python-oslo.privsep python-oslo.reports python-oslo.rootwrap
 python-oslo.service python-oslo.utils python-oslo.versionedobjects
 python-oslo.vmware python-oslotest python-osprofiler python-ovsdbapp
 python-pbr python-plaster-pastedeploy python-proliantutils python-pybedtools
 python-pycadf python-pydotplus python-pyghmi python-pyhcl python-pykmip
 python-pymemcache python-pymummer python-pyspike python-rcssmin
 python-reno python-requests-mock python-rfc3986 python-scciclient
 python-seamicroclient python-searchlightclient python-skbio
 python-sphinx-feature-classification python-sphinxcontrib.apidoc
 python-stestr python-sushy python-tempestconf python-termstyle
 python-tinyalign python-tosca-parser python-troveclient python-typepy
 python-uritemplate python-validate-pyproject python-vulndb python-watcherclient
 python-wsaccel python-wsgi-intercept python-wsme python-xstatic
 python-xstatic-angular python-xstatic-angular-bootstrap python-xstatic-angular-cookies
 python-xstatic-angular-fileupload python-xstatic-angular-gettext
 python-xstatic-angular-lrdragndrop python-xstatic-angular-mock
 python-xstatic-angular-schema-form python-xstatic-angular-ui-router
 python-xstatic-angular-uuid python-xstatic-angular-vis python-xstatic-bootstrap-datepicker
 python-xstatic-bootstrap-scss python-xstatic-bootswatch python-xstatic-dagre
 python-xstatic-dagre-d3 python-xstatic-filesaver python-xstatic-font-awesome
 python-xstatic-graphlib python-xstatic-hogan python-xstatic-jasmine
 python-xstatic-jquery python-xstatic-jquery-migrate python-xstatic-jquery-ui
 python-xstatic-jquery.bootstrap.wizard python-xstatic-jquery.quicksearch
 python-xstatic-jquery.tablesorter python-xstatic-js-yaml python-xstatic-jsencrypt
 python-xstatic-json2yaml python-xstatic-lodash python-xstatic-magic-search
 python-xstatic-mdi python-xstatic-moment python-xstatic-moment-timezone
 python-xstatic-objectpath python-xstatic-qunit python-xstatic-rickshaw
 python-xstatic-roboto-fontface python-xstatic-smart-table python-xstatic-spin
 python-xstatic-term.js python-xstatic-tv4 python-xvfbwrapper python-yappi
 python-yaql python-zake python-zaqarclient python-zunclient qrisk2
 qtbase-opensource-src qtbase-opensource-src-gles qtfeedback-opensource-src
 r-bioc-rhdf5filters r-bioc-rhtslib r-cran-data.table rabbitmq-server
 raritan-json-rpc-sdk re2c reprepro reprof reproject retroarch
 rime-cantonese ring-clojure rocblas rocfft rt-extension-jsgantt
 rt-extension-mergeusers runc rust-gping rust-ureq rustc samba
 sane-backends saods9 sccache sch-rnd scikit-learn scipy scolasync
 sentencepiece sep sfepy silx sixer snakemake sphinxcontrib-pecanwsme
 sphinxcontrib-programoutput ssh-cron ssl-utils-clojure statsmodels stimfit
 subversion supermin tbox telemetry-tempest-plugin tempest tempest-horizon
 texmaker texstudio theme-d timew tinygltf todoman tortoize trove-dashboard
 trove-tempest-plugin turing typer typeshed udm unicorn-engine
 virtualjaguar vitrage-dashboard vitrage-tempest-plugin vramsteg
 vulkan-loader watcher watcher-dashboard watcher-tempest-plugin
 weather-util x2goclient xdp-tools xfe xfig xfsprogs xmlsec1 xraylarch
 xscreensaver xxdiff yara zaqar zaqar-tempest-plugin zaqar-ui
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Sun, 25 Jan 2026 16:09:25 +0000

Processing commands for control@bugs.debian.org:

> # will reopen with some version later as they are happening again
> unarchive 1043628
Bug #1043628 {Done: xiao sheng wen <atzlinux@sina.com>} [src:apvlv] apvlv: =
Fails to build source after successful build
Unarchived Bug 1043628
> unarchive 1043642
Bug #1043642 {Done: Dennis Braun <snd@debian.org>} [src:avldrums.lv2] avldr=
ums.lv2: Fails to build source after successful build
Unarchived Bug 1043642
> unarchive 1043647
Bug #1043647 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:bali-p=
hy] bali-phy: Fails to build source after successful build
Unarchived Bug 1043647
> unarchive 1043650
Bug #1043650 {Done: Elena Grandi <valhalla@debian.org>} [src:bepasty] bepas=
ty: Fails to build source after successful build
Unarchived Bug 1043650
> unarchive 1043669
Bug #1043669 {Done: Picca Fr=C3=A9d=C3=A9ric-Emmanuel <picca@debian.org>} [=
src:bitshuffle] bitshuffle: Fails to build source after successful build
Unarchived Bug 1043669
> unarchive 1043679
Bug #1043679 {Done: tony mancill <tmancill@debian.org>} [src:cloc] cloc: Fa=
ils to build source after successful build
Unarchived Bug 1043679
> unarchive 1043695
> unarchive 1043705
Bug #1043705 {Done: Vincent Cheng <vcheng@debian.org>} [src:0ad] 0ad: Fails=
 to build source after successful build
Unarchived Bug 1043705
> unarchive 1043723
Bug #1043723 {Done: Thomas Goirand <zigo@debian.org>} [src:cinder-tempest-p=
lugin] cinder-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1043723
> unarchive 1043725
Bug #1043725 {Done: St=C3=A9phane Glondu <glondu@debian.org>} [src:belenios=
] belenios: Fails to build source after successful build
Unarchived Bug 1043725
> unarchive 1043738
Bug #1043738 {Done: Andreas Tille <andreas@an3as.eu>} [src:biomaj3-process]=
 biomaj3-process: Fails to build source after successful build
Unarchived Bug 1043738
> unarchive 1043780
Bug #1043780 {Done: Abou Al Montacir <abou.almontacir@sfr.fr>} [src:castle-=
game-engine] castle-game-engine: Fails to build source after successful bui=
ld
Unarchived Bug 1043780
> unarchive 1043791
Bug #1043791 {Done: Nobuhiro Iwamatsu <iwamatsu@debian.org>} [src:bzip3] bz=
ip3: Fails to build source after successful build
Unarchived Bug 1043791
> unarchive 1043815
Bug #1043815 {Done: Thomas Goirand <zigo@debian.org>} [src:barbican-tempest=
-plugin] barbican-tempest-plugin: Fails to build source after successful bu=
ild
Unarchived Bug 1043815
> unarchive 1043846
Bug #1043846 {Done: Andreas Tille <tille@debian.org>} [src:biomaj3-download=
] biomaj3-download: Fails to build source after successful build
Unarchived Bug 1043846
> unarchive 1043853
Bug #1043853 {Done: Yadd <yadd@debian.org>} [src:coffeescript] coffeescript=
: Fails to build source after successful build
Unarchived Bug 1043853
> unarchive 1043859
Bug #1043859 {Done: Thomas Goirand <zigo@debian.org>} [src:ceilometer-insta=
nce-poller] ceilometer-instance-poller: Fails to build source after success=
ful build
Unarchived Bug 1043859
> unarchive 1043875
Bug #1043875 {Done: A. Maitland Bottoms <bottoms@debian.org>} [src:bladerf]=
 bladerf: Fails to build source after successful build
Unarchived Bug 1043875
> unarchive 1043877
Bug #1043877 {Done: Samuel Thibault <sthibault@debian.org>} [src:ccsm] ccsm=
: Fails to build source after successful build
Unarchived Bug 1043877
> unarchive 1043897
Bug #1043897 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:cif-=
tools] cif-tools: Fails to build source after successful build
Unarchived Bug 1043897
> unarchive 1043901
Bug #1043901 {Done: Thorsten Alteholz <debian@alteholz.de>} [src:astap] ast=
ap: Fails to build source after successful build
Unarchived Bug 1043901
> unarchive 1043919
Bug #1043919 {Done: Francois Marier <francois@debian.org>} [src:atool] atoo=
l: Fails to build source after successful build
Unarchived Bug 1043919
> unarchive 1043920
Bug #1043920 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:brian]=
 brian: Fails to build source after successful build
Unarchived Bug 1043920
> unarchive 1043921
Bug #1043921 {Done: Thomas Goirand <zigo@debian.org>} [src:cloudkitty-dashb=
oard] cloudkitty-dashboard: Fails to build source after successful build
Unarchived Bug 1043921
> unarchive 1043955
Bug #1043955 {Done: Dennis Braun <snd@debian.org>} [src:abcmidi] abcmidi: F=
ails to build source after successful build
Unarchived Bug 1043955
> unarchive 1043959
Bug #1043959 {Done: Bdale Garbee <bdale@gag.com>} [src:as31] as31: Fails to=
 build source after successful build
Unarchived Bug 1043959
> unarchive 1043960
Bug #1043960 {Done: Andreas Tille <tille@debian.org>} [src:artfastqgenerato=
r] artfastqgenerator: Fails to build source after successful build
Unarchived Bug 1043960
> unarchive 1043963
Bug #1043963 {Done: Chris Carr <rantingman@gmail.com>} [src:angband] angban=
d: Fails to build source after successful build
Unarchived Bug 1043963
> unarchive 1043989
Bug #1043989 {Done: Thomas Goirand <zigo@debian.org>} [src:cloudkitty] clou=
dkitty: Fails to build source after successful build
Unarchived Bug 1043989
> unarchive 1044007
Bug #1044007 {Done: Adam Borowski <kilobyte@angband.pl>} [src:btrfs-progs] =
btrfs-progs: Fails to build source after successful build
Unarchived Bug 1044007
> unarchive 1044015
Bug #1044015 {Done: Pino Toscano <pino@debian.org>} [src:clazy] clazy: Fail=
s to build source after successful build
Unarchived Bug 1044015
> unarchive 1044018
Bug #1044018 {Done: Thomas Goirand <zigo@debian.org>} [src:cloudkitty-tempe=
st-plugin] cloudkitty-tempest-plugin: Fails to build source after successfu=
l build
Unarchived Bug 1044018
> unarchive 1044020
Bug #1044020 {Done: Andreas Tille <tille@debian.org>} [src:clonalframeml] c=
lonalframeml: Fails to build source after successful build
Unarchived Bug 1044020
> unarchive 1044022
Bug #1044022 {Done: Joseph Nahmias <jello@debian.org>} [src:christianriesen=
-base32] christianriesen-base32: Fails to build source after successful bui=
ld
Unarchived Bug 1044022
> unarchive 1044028
Bug #1044028 {Done: Thomas Goirand <zigo@debian.org>} [src:cinder] cinder: =
Fails to build source after successful build
Unarchived Bug 1044028
> unarchive 1044048
Bug #1044048 {Done: Timo Aaltonen <tjaalton@debian.org>} [src:certmonger] c=
ertmonger: Fails to build source after successful build
Unarchived Bug 1044048
> unarchive 1044090
Bug #1044090 {Done: Hilmar Preusse <hille42@web.de>} [src:asymptote] asympt=
ote: Fails to build source after successful build
Unarchived Bug 1044090
> unarchive 1044094
Bug #1044094 {Done: Gabriel F. T. Gomes <gabriel@debian.org>} [src:bash-com=
pletion] bash-completion: Fails to build source after successful build
Unarchived Bug 1044094
> unarchive 1044095
Bug #1044095 {Done: Martin Pitt <mpitt@debian.org>} [src:cockpit] cockpit: =
Fails to build source after successful build
Unarchived Bug 1044095
> unarchive 1044103
Bug #1044103 {Done: Ole Streicher <olebole@debian.org>} [src:astrometry.net=
] astrometry.net: Fails to build source after successful build
Unarchived Bug 1044103
> unarchive 1044109
> unarchive 1044141
Bug #1044141 {Done: ChangZhuo Chen (=E9=99=B3=E6=98=8C=E5=80=AC) <czchen@de=
bian.org>} [src:gpicview] gpicview: Fails to build source after successful =
build
Unarchived Bug 1044141
> unarchive 1044144
Bug #1044144 {Done: Daniel Baumann <daniel.baumann@progress-linux.org>} [sr=
c:gnome-shell-extensions-extra] gnome-shell-extensions-extra: Fails to buil=
d source after successful build
Unarchived Bug 1044144
> unarchive 1044156
Bug #1044156 {Done: Jerome BENOIT <calculus@rezozer.net>} [src:gap-factint]=
 gap-factint: Fails to build source after successful build
Unarchived Bug 1044156
> unarchive 1044166
Bug #1044166 {Done: Alexandre Detiste <tchet@debian.org>} [src:enigma] enig=
ma: Fails to build source after successful build
Unarchived Bug 1044166
> unarchive 1044194
Bug #1044194 {Done: Thomas Goirand <zigo@debian.org>} [src:glance-tempest-p=
lugin] glance-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1044194
> unarchive 1044205
Bug #1044205 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:findim=
agedupes] findimagedupes: Fails to build source after successful build
Unarchived Bug 1044205
> unarchive 1044207
Bug #1044207 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-equations] c=
oq-equations: Fails to build source after successful build
Unarchived Bug 1044207
> unarchive 1044239
Bug #1044239 {Done: Thomas Goirand <zigo@debian.org>} [src:heat-dashboard] =
heat-dashboard: Fails to build source after successful build
Unarchived Bug 1044239
> unarchive 1044249
Bug #1044249 {Done: Thomas Goirand <zigo@debian.org>} [src:heat] heat: Fail=
s to build source after successful build
Unarchived Bug 1044249
> unarchive 1044251
Bug #1044251 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-elpi] coq-el=
pi: Fails to build source after successful build
Unarchived Bug 1044251
> unarchive 1044253
Bug #1044253 {Done: Andreas Tille <tille@debian.org>} [src:dicom3tools] dic=
om3tools: Fails to build source after successful build
Unarchived Bug 1044253
> unarchive 1044268
Bug #1044268 {Done: Soren Stoutner <soren@stoutner.com>} [src:electrum] ele=
ctrum: Fails to build source after successful build
Unarchived Bug 1044268
> unarchive 1044278
Bug #1044278 {Done: Alexandre Detiste <tchet@debian.org>} [src:django-pipel=
ine] django-pipeline: Fails to build source after successful build
Unarchived Bug 1044278
> unarchive 1044302
Bug #1044302 {Done: Valentin Vidic <vvidic@debian.org>} [src:crmsh] crmsh: =
Fails to build source after successful build
Unarchived Bug 1044302
> unarchive 1044439
Bug #1044439 {Done: A. Maitland Bottoms <bottoms@debian.org>} [src:gnuradio=
] gnuradio: Fails to build source after successful build
Unarchived Bug 1044439
> unarchive 1044442
Bug #1044442 {Done: Alexandre Detiste <tchet@debian.org>} [src:dosage] dosa=
ge: Fails to build source after successful build
Unarchived Bug 1044442
> unarchive 1044447
Bug #1044447 {Done: Phil Wyett <philip.wyett@kathenas.org>} [src:healpix-ja=
va] healpix-java: Fails to build source after successful build
Unarchived Bug 1044447
> unarchive 1044462
Bug #1044462 {Done: J=C3=B6rg Frings-F=C3=BCrst <debian@jff.email>} [src:gn=
ome-pie] gnome-pie: Fails to build source after successful build
Unarchived Bug 1044462
> unarchive 1044465
Bug #1044465 {Done: Andreas Tille <tille@debian.org>} [src:gubbins] gubbins=
: Fails to build source after successful build
Unarchived Bug 1044465
> unarchive 1044486
Bug #1044486 {Done: Jerome Benoit <calculus@rezozer.net>} [src:cysignals] c=
ysignals: Fails to build source after successful build
Unarchived Bug 1044486
> unarchive 1044510
Bug #1044510 {Done: Daniel Baumann <daniel.baumann@progress-linux.org>} [sr=
c:dnsjit] dnsjit: Fails to build source after successful build
Unarchived Bug 1044510
> unarchive 1044511
Bug #1044511 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-quickchick] =
coq-quickchick: Fails to build source after successful build
Unarchived Bug 1044511
> unarchive 1044550
Bug #1044550 {Done: Daniel Baumann <daniel.baumann@progress-linux.org>} [sr=
c:dnscap] dnscap: Fails to build source after successful build
Unarchived Bug 1044550
> unarchive 1044584
Bug #1044584 {Done: Thomas Goirand <zigo@debian.org>} [src:designate-dashbo=
ard] designate-dashboard: Fails to build source after successful build
Unarchived Bug 1044584
> unarchive 1044591
Bug #1044591 {Done: Boyuan Yang <byang@debian.org>} [src:deepin-icon-theme]=
 deepin-icon-theme: Fails to build source after successful build
Unarchived Bug 1044591
> unarchive 1044593
Bug #1044593 {Done: Peter Pentchev <roam@debian.org>} [src:confget] confget=
: Fails to build source after successful build
Unarchived Bug 1044593
> unarchive 1044630
Bug #1044630 {Done: Bastian Germann <bage@debian.org>} [src:dsh] dsh: Fails=
 to build source after successful build
Unarchived Bug 1044630
> unarchive 1044632
Bug #1044632 {Done: Ileana Dumitrescu <ileanadumitrescu95@gmail.com>} [src:=
giac] giac: Fails to build source after successful build
Unarchived Bug 1044632
> unarchive 1044633
Bug #1044633 {Done: Thomas Goirand <zigo@debian.org>} [src:designate-tempes=
t-plugin] designate-tempest-plugin: Fails to build source after successful =
build
Unarchived Bug 1044633
> unarchive 1044637
Bug #1044637 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq] coq: Fails =
to build source after successful build
Unarchived Bug 1044637
> unarchive 1044642
Bug #1044642 {Done: Timo Aaltonen <tjaalton@debian.org>} [src:freeipa] free=
ipa: Fails to build source after successful build
Unarchived Bug 1044642
> unarchive 1044649
Bug #1044649 {Done: Andreas Tille <tille@debian.org>} [src:ghmm] ghmm: Fail=
s to build source after successful build
Unarchived Bug 1044649
> unarchive 1044654
Bug #1044654 {Done: Bernhard Schmidt <berni@debian.org>} [src:freeradius] f=
reeradius: Fails to build source after successful build
Unarchived Bug 1044654
> unarchive 1044666
Bug #1044666 {Done: Nicolas Schodet <nico@ni.fr.eu.org>} [src:gcc-h8300-hms=
] gcc-h8300-hms: Fails to build source after successful build
Unarchived Bug 1044666
> unarchive 1044720
Bug #1044720 {Done: Georges Khaznadar <georgesk@debian.org>} [src:expeyes] =
expeyes: Fails to build source after successful build
Unarchived Bug 1044720
> unarchive 1044740
Bug #1044740 {Done: Arun Kumar Pariyar <arun@debian.org>} [src:dtkgui] dtkg=
ui: Fails to build source after successful build
Unarchived Bug 1044740
> unarchive 1044796
Bug #1044796 {Done: Ole Streicher <olebole@debian.org>} [src:healpy] healpy=
: Fails to build source after successful build
Unarchived Bug 1044796
> unarchive 1044825
Bug #1044825 {Done: Dennis Braun <snd@debian.org>} [src:elektroid] elektroi=
d: Fails to build source after successful build
Unarchived Bug 1044825
> unarchive 1044832
Bug #1044832 {Done: Andreas Tille <tille@debian.org>} [src:fastml] fastml: =
Fails to build source after successful build
Unarchived Bug 1044832
> unarchive 1044858
Bug #1044858 {Done: Jochen Sprickerhof <jspricke@debian.org>} [src:gpsbabel=
] gpsbabel: Fails to build source after successful build
Unarchived Bug 1044858
> unarchive 1044859
Bug #1044859 {Done: Andreas Tille <tille@debian.org>} [src:dita-ot] dita-ot=
: Fails to build source after successful build
Unarchived Bug 1044859
> unarchive 1044886
Bug #1044886 {Done: Samuel Thibault <sthibault@debian.org>} [src:gtg-trace]=
 gtg-trace: Fails to build source after successful build
Unarchived Bug 1044886
> unarchive 1044901
Bug #1044901 {Done: Peter Pentchev <roam@debian.org>} [src:dante] dante: Fa=
ils to build source after successful build
Unarchived Bug 1044901
> unarchive 1044915
Bug #1044915 {Done: Michael Tokarev <mjt@tls.msk.ru>} [src:emscripten] emsc=
ripten: Fails to build source after successful build
Unarchived Bug 1044915
> unarchive 1044922
Bug #1044922 {Done: Andrej Shadura <andrewsh@debian.org>} [src:eos-sdk] eos=
-sdk: Fails to build source after successful build
Unarchived Bug 1044922
> unarchive 1044936
Bug #1044936 {Done: Guilhem Moulin <guilhem@debian.org>} [src:dropbear] dro=
pbear: Fails to build source after successful build
Unarchived Bug 1044936
> unarchive 1044979
Bug #1044979 {Done: Thomas Goirand <zigo@debian.org>} [src:designate] desig=
nate: Fails to build source after successful build
Unarchived Bug 1044979
> unarchive 1044981
Bug #1044981 {Done: Thomas Goirand <zigo@debian.org>} [src:glance] glance: =
Fails to build source after successful build
Unarchived Bug 1044981
> unarchive 1044991
Bug #1044991 {Done: Simon McVittie <smcv@debian.org>} [src:gtk4] gtk4: Fail=
s to build source after successful build
Unarchived Bug 1044991
> unarchive 1044992
Bug #1044992 {Done: Patrick Matth=C3=A4i <pmatthaei@debian.org>} [src:fastn=
etmon] fastnetmon: Fails to build source after successful build
Unarchived Bug 1044992
> unarchive 1045001
> unarchive 1045029
Bug #1045029 {Done: Thomas Goirand <zigo@debian.org>} [src:heat-tempest-plu=
gin] heat-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1045029
> unarchive 1045047
Bug #1045047 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:dssp=
] dssp: Fails to build source after successful build
Unarchived Bug 1045047
> unarchive 1045073
Bug #1045073 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-stdpp] coq-s=
tdpp: Fails to build source after successful build
Unarchived Bug 1045073
> unarchive 1045076
Bug #1045076 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-interval] co=
q-interval: Fails to build source after successful build
Unarchived Bug 1045076
> unarchive 1045085
Bug #1045085 {Done: tony mancill <tmancill@debian.org>} [src:fop] fop: Fail=
s to build source after successful build
Unarchived Bug 1045085
> unarchive 1045093
Bug #1045093 {Done: PICCA Frederic-Emmanuel <frederic-emmanuel.picca@synchr=
otron-soleil.fr>} [src:h5z-zfp] h5z-zfp: Fails to build source after succes=
sful build
Unarchived Bug 1045093
> unarchive 1045112
> unarchive 1045122
Bug #1045122 {Done: Luca Boccassi <bluca@debian.org>} [src:dpdk] dpdk: Fail=
s to build source after successful build
Unarchived Bug 1045122
> unarchive 1045134
> unarchive 1045142
Bug #1045142 {Done: Scott Kitterman <scott@kitterman.com>} [src:dkimpy] dki=
mpy: Fails to build source after successful build
Unarchived Bug 1045142
> unarchive 1045150
Bug #1045150 {Done: Jonathan McDowell <noodles@earth.li>} [src:retroarch] r=
etroarch: Fails to build source after successful build
Unarchived Bug 1045150
> unarchive 1045152
Bug #1045152 {Done: Thomas Goirand <zigo@debian.org>} [src:python-kafka] py=
thon-kafka: Fails to build source after successful build
Unarchived Bug 1045152
> unarchive 1045153
Bug #1045153 {Done: Thomas Goirand <zigo@debian.org>} [src:python-marathon]=
 python-marathon: Fails to build source after successful build
Unarchived Bug 1045153
> unarchive 1045155
Bug #1045155 {Done: Dominique Dumont <dod@debian.org>} [src:libtommath] lib=
tommath: Fails to build source after successful build
Unarchived Bug 1045155
> unarchive 1045158
Bug #1045158 {Done: Antoine Le Gonidec <vv221@debian.org>} [src:mono] mono:=
 Fails to build source after successful build
Unarchived Bug 1045158
> unarchive 1045170
Bug #1045170 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular] python-xstatic-angular: Fails to build source after successful build
Unarchived Bug 1045170
> unarchive 1045186
Bug #1045186 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pyghmi] p=
ython-pyghmi: Fails to build source after successful build
Unarchived Bug 1045186
> unarchive 1045198
Bug #1045198 {Done: Thomas Goirand <zigo@debian.org>} [src:python-glancecli=
ent] python-glanceclient: Fails to build source after successful build
Unarchived Bug 1045198
> unarchive 1045199
Bug #1045199 {Done: Sandro Knau=C3=9F <hefee@debian.org>} [src:nextcloud-de=
sktop] nextcloud-desktop: Fails to build source after successful build
Unarchived Bug 1045199
> unarchive 1045213
Bug #1045213 {Done: Ludovic Rousseau <rousseau@debian.org>} [src:pyscard] p=
yscard: Fails to build source after successful build
Unarchived Bug 1045213
> unarchive 1045222
Bug #1045222 {Done: Thomas Goirand <zigo@debian.org>} [src:vitrage-dashboar=
d] vitrage-dashboard: Fails to build source after successful build
Unarchived Bug 1045222
> unarchive 1045244
Bug #1045244 {Done: Gianfranco Costamagna <locutusofborg@debian.org>} [src:=
pyfuse3] pyfuse3: Fails to build source after successful build
Unarchived Bug 1045244
> unarchive 1045267
Bug #1045267 {Done: Yangfl <mmyangfl@gmail.com>} [src:libsimpleini] libsimp=
leini: Fails to build source after successful build
Unarchived Bug 1045267
> unarchive 1045272
Bug #1045272 {Done: Thomas Goirand <zigo@debian.org>} [src:python-sushy] py=
thon-sushy: Fails to build source after successful build
Unarchived Bug 1045272
> unarchive 1045282
Bug #1045282 {Done: Thomas Goirand <zigo@debian.org>} [src:python-rcssmin] =
python-rcssmin: Fails to build source after successful build
Unarchived Bug 1045282
> unarchive 1045286
Bug #1045286 {Done: Thomas Goirand <zigo@debian.org>} [src:python-proliantu=
tils] python-proliantutils: Fails to build source after successful build
Unarchived Bug 1045286
> unarchive 1045300
Bug #1045300 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.serv=
ice] python-oslo.service: Fails to build source after successful build
Unarchived Bug 1045300
> unarchive 1045311
Bug #1045311 {Done: Andreas Tille <tille@debian.org>} [src:mira] mira: Fail=
s to build source after successful build
Unarchived Bug 1045311
> unarchive 1045316
Bug #1045316 {Done: Rebecca N. Palmer <rebecca_palmer@zoho.com>} [src:snake=
make] snakemake: Fails to build source after successful build
Unarchived Bug 1045316
> unarchive 1045355
Bug #1045355 {Done: Bdale Garbee <bdale@gag.com>} [src:pcb-rnd] pcb-rnd: Fa=
ils to build source after successful build
Unarchived Bug 1045355
> unarchive 1045357
Bug #1045357 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.vmwa=
re] python-oslo.vmware: Fails to build source after successful build
Unarchived Bug 1045357
> unarchive 1045364
Bug #1045364 {Done: Andreas Tille <tille@debian.org>} [src:oscar] oscar: Fa=
ils to build source after successful build
Unarchived Bug 1045364
> unarchive 1045366
Bug #1045366 {Done: Petter Reinholdtsen <pere@debian.org>} [src:linuxcnc] l=
inuxcnc: Fails to build source after successful build
Unarchived Bug 1045366
> unarchive 1045381
Bug #1045381 {Done: Carsten Schoenert <c.schoenert@t-online.de>} [src:pytho=
n-validate-pyproject] python-validate-pyproject: Fails to build source afte=
r successful build
Unarchived Bug 1045381
> unarchive 1045383
Bug #1045383 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pbr] pyth=
on-pbr: Fails to build source after successful build
Unarchived Bug 1045383
> unarchive 1045393
Bug #1045393 {Done: Jeremy Stanley <fungi@yuggoth.org>} [src:weather-util] =
weather-util: Fails to build source after successful build
Unarchived Bug 1045393
> unarchive 1045395
Bug #1045395 {Done: Thomas Goirand <zigo@debian.org>} [src:python-infinity]=
 python-infinity: Fails to build source after successful build
Unarchived Bug 1045395
> unarchive 1045407
Bug #1045407 {Done: Joachim Wiedorn <joodebian@joonet.de>} [src:xfe] xfe: F=
ails to build source after successful build
Unarchived Bug 1045407
> unarchive 1045412
Bug #1045412 {Done: Vincent Cheng <vcheng@debian.org>} [src:mypaint] mypain=
t: Fails to build source after successful build
Unarchived Bug 1045412
> unarchive 1045430
Bug #1045430 {Done: Nathan Scott <nathans@debian.org>} [src:pcp] pcp: Fails=
 to build source after successful build
Unarchived Bug 1045430
> unarchive 1045440
Bug #1045440 {Done: Boyuan Yang <byang@debian.org>} [src:rime-cantonese] ri=
me-cantonese: Fails to build source after successful build
Unarchived Bug 1045440
> unarchive 1045450
Bug #1045450 {Done: Thomas Goirand <zigo@debian.org>} [src:vitrage-tempest-=
plugin] vitrage-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1045450
> unarchive 1045481
Bug #1045481 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-m=
oment] python-xstatic-moment: Fails to build source after successful build
Unarchived Bug 1045481
> unarchive 1045487
Bug #1045487 {Done: Sergio de Almeida Cipriano Junior <sergiosacj@riseup.ne=
t>} [src:typer] typer: Fails to build source after successful build
Unarchived Bug 1045487
> unarchive 1045493
Bug #1045493 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ceilomete=
rmiddleware] python-ceilometermiddleware: Fails to build source after succe=
ssful build
Unarchived Bug 1045493
> unarchive 1045510
Bug #1045510 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-q=
unit] python-xstatic-qunit: Fails to build source after successful build
Unarchived Bug 1045510
> unarchive 1045515
Bug #1045515 {Done: Jussi Pakkanen <jpakkane@gmail.com>} [src:meson] meson:=
 Fails to build source after successful build
Unarchived Bug 1045515
> unarchive 1045526
Bug #1045526 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.conf=
ig] python-oslo.config: Fails to build source after successful build
Unarchived Bug 1045526
> unarchive 1045535
Bug #1045535 {Done: Andreas Tille <tille@debian.org>} [src:jellyfish1] jell=
yfish1: Fails to build source after successful build
Unarchived Bug 1045535
> unarchive 1045566
Bug #1045566 {Done: Thomas Goirand <zigo@debian.org>} [src:zaqar-ui] zaqar-=
ui: Fails to build source after successful build
Unarchived Bug 1045566
> unarchive 1045567
Bug #1045567 {Done: Bastian Germann <bage@debian.org>} [src:reprepro] repre=
pro: Fails to build source after successful build
Unarchived Bug 1045567
> unarchive 1045587
Bug #1045587 {Done: Hilko Bengen <bengen@debian.org>} [src:libqcow] libqcow=
: Fails to build source after successful build
Unarchived Bug 1045587
> unarchive 1045609
Bug #1045609 {Done: Thomas Goirand <zigo@debian.org>} [src:python-neutroncl=
ient] python-neutronclient: Fails to build source after successful build
Unarchived Bug 1045609
> unarchive 1045611
Bug #1045611 {Done: St=C3=A9phane Glondu <glondu@debian.org>} [src:ocaml-be=
nchmark] ocaml-benchmark: Fails to build source after successful build
Unarchived Bug 1045611
> unarchive 1045615
Bug #1045615 {Done: Georges Khaznadar <georgesk@debian.org>} [src:turing] t=
uring: Fails to build source after successful build
Unarchived Bug 1045615
> unarchive 1045618
Bug #1045618 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-servic=
e-types] python-os-service-types: Fails to build source after successful bu=
ild
Unarchived Bug 1045618
> unarchive 1045619
Bug #1045619 {Done: Thomas Goirand <zigo@debian.org>} [src:python-wsgi-inte=
rcept] python-wsgi-intercept: Fails to build source after successful build
Unarchived Bug 1045619
> unarchive 1045639
Bug #1045639 {Done: Martin Pitt <mpitt@debian.org>} [src:libssh] libssh: Fa=
ils to build source after successful build
Unarchived Bug 1045639
> unarchive 1045642
Bug #1045642 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-d=
agre] python-xstatic-dagre: Fails to build source after successful build
Unarchived Bug 1045642
> unarchive 1045651
Bug #1045651 {Done: Thomas Goirand <zigo@debian.org>} [src:python-morph] py=
thon-morph: Fails to build source after successful build
Unarchived Bug 1045651
> unarchive 1045653
Bug #1045653 {Done: Thomas Goirand <zigo@debian.org>} [src:watcher-dashboar=
d] watcher-dashboard: Fails to build source after successful build
Unarchived Bug 1045653
> unarchive 1045662
Bug #1045662 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.priv=
sep] python-oslo.privsep: Fails to build source after successful build
Unarchived Bug 1045662
> unarchive 1045672
Bug #1045672 {Done: Hilko Bengen <bengen@debian.org>} [src:yara] yara: Fail=
s to build source after successful build
Unarchived Bug 1045672
> unarchive 1045678
Bug #1045678 {Done: A. Maitland Bottoms <bottoms@debian.org>} [src:libiio] =
libiio: Fails to build source after successful build
Unarchived Bug 1045678
> unarchive 1045694
Bug #1045694 {Done: Andrew Ruthven <andrew@etc.gen.nz>} [src:rt-extension-m=
ergeusers] rt-extension-mergeusers: Fails to build source after successful =
build
Unarchived Bug 1045694
> unarchive 1045706
Bug #1045706 {Done: Andreas Tille <tille@debian.org>} [src:r-bioc-rhdf5filt=
ers] r-bioc-rhdf5filters: Fails to build source after successful build
Unarchived Bug 1045706
> unarchive 1045710
Bug #1045710 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-uuid] python-xstatic-angular-uuid: Fails to build source after succe=
ssful build
Unarchived Bug 1045710
> unarchive 1045716
Bug #1045716 {Done: Thomas Goirand <zigo@debian.org>} [src:python-msgpack] =
python-msgpack: Fails to build source after successful build
Unarchived Bug 1045716
> unarchive 1045732
Bug #1045732 {Done: Thomas Goirand <zigo@debian.org>} [src:python-cursive] =
python-cursive: Fails to build source after successful build
Unarchived Bug 1045732
> unarchive 1045748
Bug #1045748 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-m=
di] python-xstatic-mdi: Fails to build source after successful build
Unarchived Bug 1045748
> unarchive 1045749
Bug #1045749 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.metr=
ics] python-oslo.metrics: Fails to build source after successful build
Unarchived Bug 1045749
> unarchive 1045759
Bug #1045759 {Done: Thomas Goirand <zigo@debian.org>} [src:python-bashate] =
python-bashate: Fails to build source after successful build
Unarchived Bug 1045759
> unarchive 1045761
Bug #1045761 {Done: Thomas Goirand <zigo@debian.org>} [src:trove-tempest-pl=
ugin] trove-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1045761
> unarchive 1045771
Bug #1045771 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query.tablesorter] python-xstatic-jquery.tablesorter: Fails to build source=
 after successful build
Unarchived Bug 1045771
> unarchive 1045774
Bug #1045774 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-sfc] =
networking-sfc: Fails to build source after successful build
Unarchived Bug 1045774
> unarchive 1045775
> unarchive 1045791
Bug #1045791 {Done: Thomas Goirand <zigo@debian.org>} [src:masakari-monitor=
s] masakari-monitors: Fails to build source after successful build
Unarchived Bug 1045791
> unarchive 1045808
Bug #1045808 {Done: Florian Schlichting <fsfs@debian.org>} [src:xxdiff] xxd=
iff: Fails to build source after successful build
Unarchived Bug 1045808
> unarchive 1045814
Bug #1045814 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query-migrate] python-xstatic-jquery-migrate: Fails to build source after s=
uccessful build
Unarchived Bug 1045814
> unarchive 1045818
Bug #1045818 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-r=
oboto-fontface] python-xstatic-roboto-fontface: Fails to build source after=
 successful build
Unarchived Bug 1045818
> unarchive 1045822
Bug #1045822 {Done: Martin <debacle@debian.org>} [src:libervia-pubsub] libe=
rvia-pubsub: Fails to build source after successful build
Unarchived Bug 1045822
> unarchive 1045869
Bug #1045869 {Done: Thomas Goirand <zigo@debian.org>} [src:ovn] ovn: Fails =
to build source after successful build
Unarchived Bug 1045869
> unarchive 1045872
Bug #1045872 {Done: Roland Rosenfeld <roland@debian.org>} [src:xfig] xfig: =
Fails to build source after successful build
Unarchived Bug 1045872
> unarchive 1045877
Bug #1045877 {Done: Drew Parsons <dparsons@debian.org>} [src:pymatgen] pyma=
tgen: Fails to build source after successful build
Unarchived Bug 1045877
> unarchive 1045897
Bug #1045897 {Done: Andreas Tille <tille@debian.org>} [src:reprof] reprof: =
Fails to build source after successful build
Unarchived Bug 1045897
> unarchive 1045916
Bug #1045916 {Done: Georges Khaznadar <georgesk@debian.org>} [src:scolasync=
] scolasync: Fails to build source after successful build
Unarchived Bug 1045916
> unarchive 1045926
Bug #1045926 {Done: Ole Streicher <olebole@debian.org>} [src:iraf-rvsao] ir=
af-rvsao: Fails to build source after successful build
Unarchived Bug 1045926
> unarchive 1045932
Bug #1045932 {Done: Lance Lin <lq27267@gmail.com>} [src:python-tinyalign] p=
ython-tinyalign: Fails to build source after successful build
Unarchived Bug 1045932
> unarchive 1045942
Bug #1045942 {Done: Matthias Geiger <werdahias@riseup.net>} [src:rust-gping=
] rust-gping: Fails to build source after successful build
Unarchived Bug 1045942
> unarchive 1045949
Bug #1045949 {Done: Luca Boccassi <bluca@debian.org>} [src:libdnf] libdnf: =
Fails to build source after successful build
Unarchived Bug 1045949
> unarchive 1045954
Bug #1045954 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ironic-in=
spector-client] python-ironic-inspector-client: Fails to build source after=
 successful build
Unarchived Bug 1045954
> unarchive 1045967
Bug #1045967 {Done: Thomas Goirand <zigo@debian.org>} [src:telemetry-tempes=
t-plugin] telemetry-tempest-plugin: Fails to build source after successful =
build
Unarchived Bug 1045967
> unarchive 1045968
Bug #1045968 {Done: Thomas Goirand <zigo@debian.org>} [src:python-django-ap=
pconf] python-django-appconf: Fails to build source after successful build
Unarchived Bug 1045968
> unarchive 1045981
Bug #1045981 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-l=
odash] python-xstatic-lodash: Fails to build source after successful build
Unarchived Bug 1045981
> unarchive 1045986
Bug #1045986 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:tort=
oize] tortoize: Fails to build source after successful build
Unarchived Bug 1045986
> unarchive 1045988
Bug #1045988 {Done: Bastian Germann <bage@debian.org>} [src:xfsprogs] xfspr=
ogs: Fails to build source after successful build
Unarchived Bug 1045988
> unarchive 1046018
Bug #1046018 {Done: Bernd Zeimetz <bzed@debian.org>} [src:open-vm-tools] op=
en-vm-tools: Fails to build source after successful build
Unarchived Bug 1046018
> unarchive 1046021
Bug #1046021 {Done: Thomas Goirand <zigo@debian.org>} [src:zaqar-tempest-pl=
ugin] zaqar-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1046021
> unarchive 1046082
Bug #1046082 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.midd=
leware] python-oslo.middleware: Fails to build source after successful build
Unarchived Bug 1046082
> unarchive 1046090
Bug #1046090 {Done: Thomas Goirand <zigo@debian.org>} [src:python-osprofile=
r] python-osprofiler: Fails to build source after successful build
Unarchived Bug 1046090
> unarchive 1046108
Bug #1046108 {Done: Thomas Goirand <zigo@debian.org>} [src:python-debtcolle=
ctor] python-debtcollector: Fails to build source after successful build
Unarchived Bug 1046108
> unarchive 1046125
Bug #1046125 {Done: Thomas Goirand <zigo@debian.org>} [src:tempest] tempest=
: Fails to build source after successful build
Unarchived Bug 1046125
> unarchive 1046156
Bug #1046156 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-refres=
h-config] python-os-refresh-config: Fails to build source after successful =
build
Unarchived Bug 1046156
> unarchive 1046167
Bug #1046167 {Done: gregor herrmann <gregoa@debian.org>} [src:liblocale-get=
text-perl] liblocale-gettext-perl: Fails to build source after successful b=
uild
Unarchived Bug 1046167
> unarchive 1046169
Bug #1046169 {Done: Thomas Goirand <zigo@debian.org>} [src:ironic-ui] ironi=
c-ui: Fails to build source after successful build
Unarchived Bug 1046169
> unarchive 1046172
Bug #1046172 {Done: Thomas Goirand <zigo@debian.org>} [src:python-calmjs.pa=
rse] python-calmjs.parse: Fails to build source after successful build
Unarchived Bug 1046172
> unarchive 1046175
Bug #1046175 {Done: Stefano Rivera <stefanor@debian.org>} [src:numpy] numpy=
: Fails to build source after successful build
Unarchived Bug 1046175
> unarchive 1046176
Bug #1046176 {Done: J=C3=A9r=C3=B4me Charaoui <jerome@riseup.net>} [src:rin=
g-clojure] ring-clojure: Fails to build source after successful build
Unarchived Bug 1046176
> unarchive 1046201
Bug #1046201 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.i18n=
] python-oslo.i18n: Fails to build source after successful build
Unarchived Bug 1046201
> unarchive 1046221
Bug #1046221 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-b=
ootstrap-scss] python-xstatic-bootstrap-scss: Fails to build source after s=
uccessful build
Unarchived Bug 1046221
> unarchive 1046222
Bug #1046222 {Done: Thomas Goirand <zigo@debian.org>} [src:ironic-inspector=
] ironic-inspector: Fails to build source after successful build
Unarchived Bug 1046222
> unarchive 1046233
Bug #1046233 {Done: Phil Wyett <philip.wyett@kathenas.org>} [src:mpgrafic] =
mpgrafic: Fails to build source after successful build
Unarchived Bug 1046233
> unarchive 1046238
Bug #1046238 {Done: Andreas Tille <tille@debian.org>} [src:qrisk2] qrisk2: =
Fails to build source after successful build
Unarchived Bug 1046238
> unarchive 1046253
Bug #1046253 {Done: Luca Boccassi <bluca@debian.org>} [src:xdp-tools] xdp-t=
ools: Fails to build source after successful build
Unarchived Bug 1046253
> unarchive 1046271
Bug #1046271 {Done: Dennis Braun <snd@debian.org>} [src:pyliblo] pyliblo: F=
ails to build source after successful build
Unarchived Bug 1046271
> unarchive 1046273
Bug #1046273 {Done: Thomas Goirand <zigo@debian.org>} [src:magnum-ui] magnu=
m-ui: Fails to build source after successful build
Unarchived Bug 1046273
> unarchive 1046279
Bug #1046279 {Done: Thomas Goirand <zigo@debian.org>} [src:python-barbicanc=
lient] python-barbicanclient: Fails to build source after successful build
Unarchived Bug 1046279
> unarchive 1046280
Bug #1046280 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic] =
python-xstatic: Fails to build source after successful build
Unarchived Bug 1046280
> unarchive 1046283
Bug #1046283 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ovsdbapp]=
 python-ovsdbapp: Fails to build source after successful build
Unarchived Bug 1046283
> unarchive 1046287
Bug #1046287 {Done: Thomas Goirand <zigo@debian.org>} [src:sphinxcontrib-pr=
ogramoutput] sphinxcontrib-programoutput: Fails to build source after succe=
ssful build
Unarchived Bug 1046287
> unarchive 1046290
Bug #1046290 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-t=
erm.js] python-xstatic-term.js: Fails to build source after successful build
Unarchived Bug 1046290
> unarchive 1046291
Bug #1046291 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.db] =
python-oslo.db: Fails to build source after successful build
Unarchived Bug 1046291
> unarchive 1046302
Bug #1046302 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.poli=
cy] python-oslo.policy: Fails to build source after successful build
Unarchived Bug 1046302
> unarchive 1046311
Bug #1046311 {Done: Roland Mas <lolando@debian.org>} [src:python-mrcfile] p=
ython-mrcfile: Fails to build source after successful build
Unarchived Bug 1046311
> unarchive 1046323
Bug #1046323 {Done: Frank B. Brokken <f.b.brokken@rug.nl>} [src:ssh-cron] s=
sh-cron: Fails to build source after successful build
Unarchived Bug 1046323
> unarchive 1046350
Bug #1046350 {Done: Thomas Goirand <zigo@debian.org>} [src:python-keystonem=
iddleware] python-keystonemiddleware: Fails to build source after successfu=
l build
Unarchived Bug 1046350
> unarchive 1046363
Bug #1046363 {Done: Gunnar Hjalmarsson <gunnarhj@debian.org>} [src:ibus-m17=
n] ibus-m17n: Fails to build source after successful build
Unarchived Bug 1046363
> unarchive 1046372
Bug #1046372 {Done: Andreas Tille <tille@debian.org>} [src:librcsb-core-wra=
pper] librcsb-core-wrapper: Fails to build source after successful build
Unarchived Bug 1046372
> unarchive 1046388
Bug #1046388 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:libp=
db-redo] libpdb-redo: Fails to build source after successful build
Unarchived Bug 1046388
> unarchive 1046396
Bug #1046396 {Done: Thomas Goirand <zigo@debian.org>} [src:python-requests-=
mock] python-requests-mock: Fails to build source after successful build
Unarchived Bug 1046396
> unarchive 1046402
Bug #1046402 {Done: Thomas Goirand <zigo@debian.org>} [src:tempest-horizon]=
 tempest-horizon: Fails to build source after successful build
Unarchived Bug 1046402
> unarchive 1046403
Bug #1046403 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query-ui] python-xstatic-jquery-ui: Fails to build source after successful =
build
Unarchived Bug 1046403
> unarchive 1046416
Bug #1046416 {Done: Nobuhiro Iwamatsu <iwamatsu@debian.org>} [src:mruby] mr=
uby: Fails to build source after successful build
Unarchived Bug 1046416
> unarchive 1046430
Bug #1046430 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
son2yaml] python-xstatic-json2yaml: Fails to build source after successful =
build
Unarchived Bug 1046430
> unarchive 1046444
Bug #1046444 {Done: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de=
>} [src:virtualjaguar] virtualjaguar: Fails to build source after successfu=
l build
Unarchived Bug 1046444
> unarchive 1046450
Bug #1046450 {Done: Paul Gevers <elbrus@debian.org>} [src:liferea] liferea:=
 Fails to build source after successful build
Unarchived Bug 1046450
> unarchive 1046451
Bug #1046451 {Done: Thomas Goirand <zigo@debian.org>} [src:python-typepy] p=
ython-typepy: Fails to build source after successful build
Unarchived Bug 1046451
> unarchive 1046452
Bug #1046452 {Done: Lance Lin <lq27267@gmail.com>} [src:python-pymummer] py=
thon-pymummer: Fails to build source after successful build
Unarchived Bug 1046452
> unarchive 1046459
Bug #1046459 {Done: Thomas Goirand <zigo@debian.org>} [src:python-openstack=
sdk] python-openstacksdk: Fails to build source after successful build
Unarchived Bug 1046459
> unarchive 1046467
Bug #1046467 {Done: Thomas Goirand <zigo@debian.org>} [src:octavia-tempest-=
plugin] octavia-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1046467
> unarchive 1046493
Bug #1046493 {Done: Drew Parsons <dparsons@debian.org>} [src:scipy] scipy: =
Fails to build source after successful build
Unarchived Bug 1046493
> unarchive 1046499
Bug #1046499 {Done: Thomas Goirand <zigo@debian.org>} [src:python-sphinxcon=
trib.apidoc] python-sphinxcontrib.apidoc: Fails to build source after succe=
ssful build
Unarchived Bug 1046499
> unarchive 1046505
Bug #1046505 {Done: Thomas Goirand <zigo@debian.org>} [src:ironic] ironic: =
Fails to build source after successful build
Unarchived Bug 1046505
> unarchive 1046512
Bug #1046512 {Done: Camm Maguire <camm@debian.org>} [src:maxima] maxima: Fa=
ils to build source after successful build
Unarchived Bug 1046512
> unarchive 1046528
Bug #1046528 {Done: Reinhard Tartler <siretart@tauware.de>} [src:runc] runc=
: Fails to build source after successful build
Unarchived Bug 1046528
> unarchive 1046531
Bug #1046531 {Done: Bdale Garbee <bdale@gag.com>} [src:sch-rnd] sch-rnd: Fa=
ils to build source after successful build
Unarchived Bug 1046531
> unarchive 1046536
Bug #1046536 {Done: Thomas Goirand <zigo@debian.org>} [src:python-django-py=
scss] python-django-pyscss: Fails to build source after successful build
Unarchived Bug 1046536
> unarchive 1046543
Bug #1046543 {Done: Mike Gabriel <sunweaver@debian.org>} [src:qtfeedback-op=
ensource-src] qtfeedback-opensource-src: Fails to build source after succes=
sful build
Unarchived Bug 1046543
> unarchive 1046551
Bug #1046551 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.util=
s] python-oslo.utils: Fails to build source after successful build
Unarchived Bug 1046551
> unarchive 1046552
Bug #1046552 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query.quicksearch] python-xstatic-jquery.quicksearch: Fails to build source=
 after successful build
Unarchived Bug 1046552
> unarchive 1046557
Bug #1046557 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-s=
mart-table] python-xstatic-smart-table: Fails to build source after success=
ful build
Unarchived Bug 1046557
> unarchive 1046561
Bug #1046561 {Done: Thomas Goirand <zigo@debian.org>} [src:python-neutron-l=
ib] python-neutron-lib: Fails to build source after successful build
Unarchived Bug 1046561
> unarchive 1046565
Bug #1046565 {Done: Thomas Goirand <zigo@debian.org>} [src:python-rfc3986] =
python-rfc3986: Fails to build source after successful build
Unarchived Bug 1046565
> unarchive 1046569
Bug #1046569 {Done: J=C3=A9r=C3=A9my Lal <kapouer@melix.org>} [src:python-c=
ryptography] python-cryptography: Fails to build source after successful bu=
ild
Unarchived Bug 1046569
> unarchive 1046571
Bug #1046571 {Done: Thomas Goirand <zigo@debian.org>} [src:manila-tempest-p=
lugin] manila-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1046571
> unarchive 1046600
Bug #1046600 {Done: Thomas Goirand <zigo@debian.org>} [src:python-wsaccel] =
python-wsaccel: Fails to build source after successful build
Unarchived Bug 1046600
> unarchive 1046604
Bug #1046604 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-t=
v4] python-xstatic-tv4: Fails to build source after successful build
Unarchived Bug 1046604
> unarchive 1046618
Bug #1046618 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.vers=
ionedobjects] python-oslo.versionedobjects: Fails to build source after suc=
cessful build
Unarchived Bug 1046618
> unarchive 1046628
Bug #1046628 {Done: Thomas Goirand <zigo@debian.org>} [src:python-autobahn]=
 python-autobahn: Fails to build source after successful build
Unarchived Bug 1046628
> unarchive 1046642
Bug #1046642 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-vis] python-xstatic-angular-vis: Fails to build source after success=
ful build
Unarchived Bug 1046642
> unarchive 1046699
Bug #1046699 {Done: Jochen Sprickerhof <jspricke@debian.org>} [src:olm] olm=
: Fails to build source after successful build
Unarchived Bug 1046699
> unarchive 1046710
Bug #1046710 {Done: Thomas Goirand <zigo@debian.org>} [src:python-logutils]=
 python-logutils: Fails to build source after successful build
Unarchived Bug 1046710
> unarchive 1046712
Bug #1046712 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pyhcl] py=
thon-pyhcl: Fails to build source after successful build
Unarchived Bug 1046712
> unarchive 1046716
Bug #1046716 {Done: Roland Mas <lolando@debian.org>} [src:xraylarch] xrayla=
rch: Fails to build source after successful build
Unarchived Bug 1046716
> unarchive 1046775
Bug #1046775 {Done: Andreas Tille <tille@debian.org>} [src:scikit-learn] sc=
ikit-learn: Fails to build source after successful build
Unarchived Bug 1046775
> unarchive 1046778
Bug #1046778 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-m=
oment-timezone] python-xstatic-moment-timezone: Fails to build source after=
 successful build
Unarchived Bug 1046778
> unarchive 1046783
Bug #1046783 {Done: J=C3=B6rg Frings-F=C3=BCrst <debian@jff.email>} [src:sa=
ne-backends] sane-backends: Fails to build source after successful build
Unarchived Bug 1046783
> unarchive 1046788
Bug #1046788 {Done: Anton Gladky <gladk@debian.org>} [src:sfepy] sfepy: Fai=
ls to build source after successful build
Unarchived Bug 1046788
> unarchive 1046789
Bug #1046789 {Done: Thomas Goirand <zigo@debian.org>} [src:python-memcache]=
 python-memcache: Fails to build source after successful build
Unarchived Bug 1046789
> unarchive 1046791
Bug #1046791 {Done: Thomas Goirand <zigo@debian.org>} [src:python-yaql] pyt=
hon-yaql: Fails to build source after successful build
Unarchived Bug 1046791
> unarchive 1046813
Bug #1046813 {Done: Thomas Goirand <zigo@debian.org>} [src:rabbitmq-server]=
 rabbitmq-server: Fails to build source after successful build
Unarchived Bug 1046813
> unarchive 1046816
Bug #1046816 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.root=
wrap] python-oslo.rootwrap: Fails to build source after successful build
Unarchived Bug 1046816
> unarchive 1046832
Bug #1046832 {Done: Thomas Goirand <zigo@debian.org>} [src:python-json-poin=
ter] python-json-pointer: Fails to build source after successful build
Unarchived Bug 1046832
> unarchive 1046843
Bug #1046843 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
asmine] python-xstatic-jasmine: Fails to build source after successful build
Unarchived Bug 1046843
> unarchive 1046849
Bug #1046849 {Done: James McCoy <jamessan@debian.org>} [src:subversion] sub=
version: Fails to build source after successful build
Unarchived Bug 1046849
> unarchive 1046864
Bug #1046864 {Done: Drew Parsons <dparsons@debian.org>} [src:hypre] hypre: =
Fails to build source after successful build
Unarchived Bug 1046864
> unarchive 1046902
> unarchive 1046913
Bug #1046913 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
sencrypt] python-xstatic-jsencrypt: Fails to build source after successful =
build
Unarchived Bug 1046913
> unarchive 1046915
Bug #1046915 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-traits=
] python-os-traits: Fails to build source after successful build
Unarchived Bug 1046915
> unarchive 1046921
Bug #1046921 {Done: Andrew Ruthven <andrew@etc.gen.nz>} [src:rt-extension-j=
sgantt] rt-extension-jsgantt: Fails to build source after successful build
Unarchived Bug 1046921
> unarchive 1046931
Bug #1046931 {Done: Thomas Goirand <zigo@debian.org>} [src:python-magnumcli=
ent] python-magnumclient: Fails to build source after successful build
Unarchived Bug 1046931
> unarchive 1046957
Bug #1046957 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-gettext] python-xstatic-angular-gettext: Fails to build source after=
 successful build
Unarchived Bug 1046957
> unarchive 1046966
Bug #1046966 {Done: Teus Benschop <teusbenschop@debian.org>} [src:libpqxx] =
libpqxx: Fails to build source after successful build
Unarchived Bug 1046966
> unarchive 1046971
Bug #1046971 {Done: Christian Kastner <ckk@debian.org>} [src:rocblas] rocbl=
as: Fails to build source after successful build
Unarchived Bug 1046971
> unarchive 1046977
Bug #1046977 {Done: Thomas Goirand <zigo@debian.org>} [src:python-wsme] pyt=
hon-wsme: Fails to build source after successful build
Unarchived Bug 1046977
> unarchive 1046994
Bug #1046994 {Done: Simon McVittie <smcv@debian.org>} [src:libsdl2-mixer] l=
ibsdl2-mixer: Fails to build source after successful build
Unarchived Bug 1046994
> unarchive 1046999
Bug #1046999 {Done: Thomas Goirand <zigo@debian.org>} [src:watcher-tempest-=
plugin] watcher-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1046999
> unarchive 1047001
Bug #1047001 {Done: Andreas Tille <tille@debian.org>} [src:timew] timew: Fa=
ils to build source after successful build
Unarchived Bug 1047001
> unarchive 1047018
Bug #1047018 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pycadf] p=
ython-pycadf: Fails to build source after successful build
Unarchived Bug 1047018
> unarchive 1047020
Bug #1047020 {Done: James McCoy <jamessan@debian.org>} [src:lua5.1] lua5.1:=
 Fails to build source after successful build
Unarchived Bug 1047020
> unarchive 1047030
Bug #1047030 {Done: Thomas Goirand <zigo@debian.org>} [src:python-reno] pyt=
hon-reno: Fails to build source after successful build
Unarchived Bug 1047030
> unarchive 1047043
Bug #1047043 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:insigh=
ttoolkit5] insighttoolkit5: Fails to build source after successful build
Unarchived Bug 1047043
> unarchive 1047070
Bug #1047070 {Done: Thomas Goirand <zigo@debian.org>} [src:magnum-tempest-p=
lugin] magnum-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1047070
> unarchive 1047089
Bug #1047089 {Done: Thomas Goirand <zigo@debian.org>} [src:python-daemonize=
] python-daemonize: Fails to build source after successful build
Unarchived Bug 1047089
> unarchive 1047091
Bug #1047091 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ldappool]=
 python-ldappool: Fails to build source after successful build
Unarchived Bug 1047091
> unarchive 1047097
Bug #1047097 {Done: Thomas Goirand <zigo@debian.org>} [src:python-designate=
client] python-designateclient: Fails to build source after successful build
Unarchived Bug 1047097
> unarchive 1047105
Bug #1047105 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-r=
ickshaw] python-xstatic-rickshaw: Fails to build source after successful bu=
ild
Unarchived Bug 1047105
> unarchive 1047135
Bug #1047135 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-resour=
ce-classes] python-os-resource-classes: Fails to build source after success=
ful build
Unarchived Bug 1047135
> unarchive 1047146
Bug #1047146 {Done: Christoph Schmidt-Hieber <christsc@gmx.de>} [src:stimfi=
t] stimfit: Fails to build source after successful build
Unarchived Bug 1047146
> unarchive 1047161
Bug #1047161 {Done: Thomas Goirand <zigo@debian.org>} [src:python-dogpile.c=
ache] python-dogpile.cache: Fails to build source after successful build
Unarchived Bug 1047161
> unarchive 1047182
Bug #1047182 {Done: Thomas Goirand <zigo@debian.org>} [src:mistral-tempest-=
plugin] mistral-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1047182
> unarchive 1047192
Bug #1047192 {Done: Thomas Goirand <zigo@debian.org>} [src:python-octavia-l=
ib] python-octavia-lib: Fails to build source after successful build
Unarchived Bug 1047192
> unarchive 1047194
Bug #1047194 {Done: Tom Jampen <tom@cryptography.ch>} [src:texstudio] texst=
udio: Fails to build source after successful build
Unarchived Bug 1047194
> unarchive 1047199
Bug #1047199 {Done: Drew Parsons <dparsons@debian.org>} [src:petsc4py] pets=
c4py: Fails to build source after successful build
Unarchived Bug 1047199
> unarchive 1047202
Bug #1047202 {Done: Agustin Martin Domingo <agmartin@debian.org>} [src:ispe=
ll-fo] ispell-fo: Fails to build source after successful build
Unarchived Bug 1047202
> unarchive 1047205
Bug #1047205 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-barem=
etal] networking-baremetal: Fails to build source after successful build
Unarchived Bug 1047205
> unarchive 1047213
Bug #1047213 {Done: Philip Hands <phil@hands.com>} [src:os-autoinst] os-aut=
oinst: Fails to build source after successful build
Unarchived Bug 1047213
> unarchive 1047244
Bug #1047244 {Done: Ole Streicher <olebole@debian.org>} [src:reproject] rep=
roject: Fails to build source after successful build
Unarchived Bug 1047244
> unarchive 1047249
Bug #1047249 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-testr]=
 python-os-testr: Fails to build source after successful build
Unarchived Bug 1047249
> unarchive 1047254
Bug #1047254 {Done: Thomas Goirand <zigo@debian.org>} [src:sphinxcontrib-pe=
canwsme] sphinxcontrib-pecanwsme: Fails to build source after successful bu=
ild
Unarchived Bug 1047254
> unarchive 1047264
Bug #1047264 {Done: Jonas Smedegaard <dr@jones.dk>} [src:rust-ureq] rust-ur=
eq: Fails to build source after successful build
Unarchived Bug 1047264
> unarchive 1047280
Bug #1047280 {Done: Rebecca N. Palmer <rebecca_palmer@zoho.com>} [src:stats=
models] statsmodels: Fails to build source after successful build
Unarchived Bug 1047280
> unarchive 1047288
Bug #1047288 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.cach=
e] python-oslo.cache: Fails to build source after successful build
Unarchived Bug 1047288
> unarchive 1047318
Bug #1047318 {Done: Samuel Thibault <sthibault@debian.org>} [src:liblouis] =
liblouis: Fails to build source after successful build
Unarchived Bug 1047318
> unarchive 1047327
Bug #1047327 {Done: Gunnar Hjalmarsson <gunnarhj@debian.org>} [src:ibus-tab=
le] ibus-table: Fails to build source after successful build
Unarchived Bug 1047327
> unarchive 1047333
Bug #1047333 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:ivar] =
ivar: Fails to build source after successful build
Unarchived Bug 1047333
> unarchive 1047356
Bug #1047356 {Done: Thorsten Alteholz <debian@alteholz.de>} [src:udm] udm: =
Fails to build source after successful build
Unarchived Bug 1047356
> unarchive 1047384
Bug #1047384 {Done: Thomas Goirand <zigo@debian.org>} [src:zaqar] zaqar: Fa=
ils to build source after successful build
Unarchived Bug 1047384
> unarchive 1047394
Bug #1047394 {Done: Thomas Goirand <zigo@debian.org>} [src:python-zaqarclie=
nt] python-zaqarclient: Fails to build source after successful build
Unarchived Bug 1047394
> unarchive 1047401
Bug #1047401 {Done: Roland Gruber <post@rolandgruber.de>} [src:ldap-account=
-manager] ldap-account-manager: Fails to build source after successful build
Unarchived Bug 1047401
> unarchive 1047422
Bug #1047422 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-lrdragndrop] python-xstatic-angular-lrdragndrop: Fails to build sour=
ce after successful build
Unarchived Bug 1047422
> unarchive 1047423
Bug #1047423 {Done: Antonio Valentino <antonio.valentino@tiscali.it>} [src:=
pyerfa] pyerfa: Fails to build source after successful build
Unarchived Bug 1047423
> unarchive 1047431
Bug #1047431 {Done: Thomas Goirand <zigo@debian.org>} [src:masakari-dashboa=
rd] masakari-dashboard: Fails to build source after successful build
Unarchived Bug 1047431
> unarchive 1047466
Bug #1047466 {Done: Thomas Goirand <zigo@debian.org>} [src:python-keystonec=
lient] python-keystoneclient: Fails to build source after successful build
Unarchived Bug 1047466
> unarchive 1047472
Bug #1047472 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.log]=
 python-oslo.log: Fails to build source after successful build
Unarchived Bug 1047472
> unarchive 1047478
Bug #1047478 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-mock] python-xstatic-angular-mock: Fails to build source after succe=
ssful build
Unarchived Bug 1047478
> unarchive 1047482
Bug #1047482 {Done: Thomas Goirand <zigo@debian.org>} [src:manila] manila: =
Fails to build source after successful build
Unarchived Bug 1047482
> unarchive 1047490
Bug #1047490 {Done: Jelmer Vernoo=C4=B3 <jelmer@jelmer.uk>} [src:python-fas=
tbencode] python-fastbencode: Fails to build source after successful build
Unarchived Bug 1047490
> unarchive 1047493
Bug #1047493 {Done: Andreas Tille <tille@debian.org>} [src:r-bioc-rhtslib] =
r-bioc-rhtslib: Fails to build source after successful build
Unarchived Bug 1047493
> unarchive 1047498
Bug #1047498 {Done: Thomas Goirand <zigo@debian.org>} [src:python-fixtures]=
 python-fixtures: Fails to build source after successful build
Unarchived Bug 1047498
> unarchive 1047502
Bug #1047502 {Done: Ralf Treinen <treinen@debian.org>} [src:planets] planet=
s: Fails to build source after successful build
Unarchived Bug 1047502
> unarchive 1047524
Bug #1047524 {Done: Thomas Goirand <zigo@debian.org>} [src:openstack-trove]=
 openstack-trove: Fails to build source after successful build
Unarchived Bug 1047524
> unarchive 1047547
Bug #1047547 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-s=
pin] python-xstatic-spin: Fails to build source after successful build
Unarchived Bug 1047547
> unarchive 1047552
Bug #1047552 {Done: Kentaro Hayashi <kenhys@xdump.org>} [src:sentencepiece]=
 sentencepiece: Fails to build source after successful build
Unarchived Bug 1047552
> unarchive 1047555
Bug #1047555 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query] python-xstatic-jquery: Fails to build source after successful build
Unarchived Bug 1047555
> unarchive 1047562
Bug #1047562 {Done: Picca Fr=C3=A9d=C3=A9ric-Emmanuel <picca@debian.org>} [=
src:silx] silx: Fails to build source after successful build
Unarchived Bug 1047562
> unarchive 1047573
Bug #1047573 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pymemcach=
e] python-pymemcache: Fails to build source after successful build
Unarchived Bug 1047573
> unarchive 1047576
Bug #1047576 {Done: Carsten Schoenert <c.schoenert@t-online.de>} [src:rarit=
an-json-rpc-sdk] raritan-json-rpc-sdk: Fails to build source after successf=
ul build
Unarchived Bug 1047576
> unarchive 1047577
Bug #1047577 {Done: Nilesh Patra <nilesh@debian.org>} [src:nmodl] nmodl: Fa=
ils to build source after successful build
Unarchived Bug 1047577
> unarchive 1047597
Bug #1047597 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-f=
ilesaver] python-xstatic-filesaver: Fails to build source after successful =
build
Unarchived Bug 1047597
> unarchive 1047612
Bug #1047612 {Done: Michael R. Crusoe <crusoe@debian.org>} [src:macs] macs:=
 Fails to build source after successful build
Unarchived Bug 1047612
> unarchive 1047621
Bug #1047621 {Done: Dima Kogan <dkogan@debian.org>} [src:notion] notion: Fa=
ils to build source after successful build
Unarchived Bug 1047621
> unarchive 1047643
Bug #1047643 {Done: Rene Engelhard <rene@debian.org>} [src:xmlsec1] xmlsec1=
: Fails to build source after successful build
Unarchived Bug 1047643
> unarchive 1047663
Bug #1047663 {Done: Thomas Goirand <zigo@debian.org>} [src:python-mbstrdeco=
der] python-mbstrdecoder: Fails to build source after successful build
Unarchived Bug 1047663
> unarchive 1047665
Bug #1047665 {Done: Thomas Goirand <zigo@debian.org>} [src:python-zunclient=
] python-zunclient: Fails to build source after successful build
Unarchived Bug 1047665
> unarchive 1047688
Bug #1047688 {Done: Thomas Goirand <zigo@debian.org>} [src:python-zake] pyt=
hon-zake: Fails to build source after successful build
Unarchived Bug 1047688
> unarchive 1047705
Bug #1047705 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pykmip] p=
ython-pykmip: Fails to build source after successful build
Unarchived Bug 1047705
> unarchive 1047724
Bug #1047724 {Done: Picca Fr=C3=A9d=C3=A9ric-Emmanuel <picca@debian.org>} [=
src:python-fisx] python-fisx: Fails to build source after successful build
Unarchived Bug 1047724
> unarchive 1047735
Bug #1047735 {Done: Thomas Goirand <zigo@debian.org>} [src:neutron-vpnaas-d=
ashboard] neutron-vpnaas-dashboard: Fails to build source after successful =
build
Unarchived Bug 1047735
> unarchive 1047738
Bug #1047738 {Done: Thomas Goirand <zigo@debian.org>} [src:python-yappi] py=
thon-yappi: Fails to build source after successful build
Unarchived Bug 1047738
> unarchive 1047747
Bug #1047747 {Done: Thomas Goirand <zigo@debian.org>} [src:python-osc-place=
ment] python-osc-placement: Fails to build source after successful build
Unarchived Bug 1047747
> unarchive 1047756
Bug #1047756 {Done: Thomas Goirand <zigo@debian.org>} [src:python-stestr] p=
ython-stestr: Fails to build source after successful build
Unarchived Bug 1047756
> unarchive 1047769
Bug #1047769 {Done: Drew Parsons <dparsons@debian.org>} [src:matplotlib] ma=
tplotlib: Fails to build source after successful build
Unarchived Bug 1047769
> unarchive 1047790
Bug #1047790 {Done: Martin <debacle@debian.org>} [src:poezio] poezio: Fails=
 to build source after successful build
Unarchived Bug 1047790
> unarchive 1047791
Bug #1047791 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-b=
ootstrap-datepicker] python-xstatic-bootstrap-datepicker: Fails to build so=
urce after successful build
Unarchived Bug 1047791
> unarchive 1047792
Bug #1047792 {Done: Thomas Goirand <zigo@debian.org>} [src:python-dracclien=
t] python-dracclient: Fails to build source after successful build
Unarchived Bug 1047792
> unarchive 1047819
Bug #1047819 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-win] p=
ython-os-win: Fails to build source after successful build
Unarchived Bug 1047819
> unarchive 1047823
Bug #1047823 {Done: F=C3=A9lix Sipma <felix@debian.org>} [src:todoman] todo=
man: Fails to build source after successful build
Unarchived Bug 1047823
> unarchive 1047826
Bug #1047826 {Done: Thomas Goirand <zigo@debian.org>} [src:python-json-patc=
h] python-json-patch: Fails to build source after successful build
Unarchived Bug 1047826
> unarchive 1047831
Bug #1047831 {Done: Lance Lin <lq27267@gmail.com>} [src:tbox] tbox: Fails t=
o build source after successful build
Unarchived Bug 1047831
> unarchive 1047834
Bug #1047834 {Done: Gard Spreemann <gspr@nonempty.org>} [src:python-pyspike=
] python-pyspike: Fails to build source after successful build
Unarchived Bug 1047834
> unarchive 1047835
Bug #1047835 {Done: Thomas Goirand <zigo@debian.org>} [src:neutron-tempest-=
plugin] neutron-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1047835
> unarchive 1047884
Bug #1047884 {Done: Picca Fr=C3=A9d=C3=A9ric-Emmanuel <picca@debian.org>} [=
src:python-hdf5plugin] python-hdf5plugin: Fails to build source after succe=
ssful build
Unarchived Bug 1047884
> unarchive 1047898
Bug #1047898 {Done: Helge Kreutzmann <debian@helgefjell.de>} [src:linuxinfo=
] linuxinfo: Fails to build source after successful build
Unarchived Bug 1047898
> unarchive 1047901
Bug #1047901 {Done: Jeroen Ploemen <jcfp@debian.org>} [src:re2c] re2c: Fail=
s to build source after successful build
Unarchived Bug 1047901
> unarchive 1047930
Bug #1047930 {Done: Alberto Bertogli <albertito@blitiri.com.ar>} [src:kxd] =
kxd: Fails to build source after successful build
Unarchived Bug 1047930
> unarchive 1047937
Bug #1047937 {Done: Doug Torrance <dtorrance@debian.org>} [src:macaulay2] m=
acaulay2: Fails to build source after successful build
Unarchived Bug 1047937
> unarchive 1047946
Bug #1047946 {Done: Andreas Tille <tille@debian.org>} [src:vramsteg] vramst=
eg: Fails to build source after successful build
Unarchived Bug 1047946
> unarchive 1047954
Bug #1047954 {Done: tony mancill <tmancill@debian.org>} [src:icmake] icmake=
: Fails to build source after successful build
Unarchived Bug 1047954
> unarchive 1047961
Bug #1047961 {Done: Dima Kogan <dkogan@debian.org>} [src:python-numpysane] =
python-numpysane: Fails to build source after successful build
Unarchived Bug 1047961
> unarchive 1047969
Bug #1047969 {Done: Thomas Goirand <zigo@debian.org>} [src:python-tempestco=
nf] python-tempestconf: Fails to build source after successful build
Unarchived Bug 1047969
> unarchive 1048006
Bug #1048006 {Done: Lance Lin <lq27267@gmail.com>} [src:python-pybedtools] =
python-pybedtools: Fails to build source after successful build
Unarchived Bug 1048006
> unarchive 1048007
Bug #1048007 {Done: Andreas Tille <tille@debian.org>} [src:r-cran-data.tabl=
e] r-cran-data.table: Fails to build source after successful build
Unarchived Bug 1048007
> unarchive 1048014
Bug #1048014 {Done: Thomas Goirand <zigo@debian.org>} [src:python-cloudkitt=
yclient] python-cloudkittyclient: Fails to build source after successful bu=
ild
Unarchived Bug 1048014
> unarchive 1048018
Bug #1048018 {Done: Timo R=C3=B6hling <roehling@debian.org>} [src:tinygltf]=
 tinygltf: Fails to build source after successful build
Unarchived Bug 1048018
> unarchive 1048019
Bug #1048019 {Done: J=C3=A9r=C3=B4me Charaoui <jerome@riseup.net>} [src:ssl=
-utils-clojure] ssl-utils-clojure: Fails to build source after successful b=
uild
Unarchived Bug 1048019
> unarchive 1048023
Bug #1048023 {Done: Emmanuel Arias <eamanu@debian.org>} [src:python-hpilo] =
python-hpilo: Fails to build source after successful build
Unarchived Bug 1048023
> unarchive 1048034
Bug #1048034 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.limi=
t] python-oslo.limit: Fails to build source after successful build
Unarchived Bug 1048034
> unarchive 1048047
Bug #1048047 {Done: Nilesh Patra <nilesh@debian.org>} [src:neuron] neuron: =
Fails to build source after successful build
Unarchived Bug 1048047
> unarchive 1048050
Bug #1048050 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.mess=
aging] python-oslo.messaging: Fails to build source after successful build
Unarchived Bug 1048050
> unarchive 1048052
Bug #1048052 {Done: Thomas Goirand <zigo@debian.org>} [src:python-uritempla=
te] python-uritemplate: Fails to build source after successful build
Unarchived Bug 1048052
> unarchive 1048053
Bug #1048053 {Done: Thomas Goirand <zigo@debian.org>} [src:magnum] magnum: =
Fails to build source after successful build
Unarchived Bug 1048053
> unarchive 1048055
Bug #1048055 {Done: Thomas Goirand <zigo@debian.org>} [src:python-termstyle=
] python-termstyle: Fails to build source after successful build
Unarchived Bug 1048055
> unarchive 1048056
Bug #1048056 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ironic-li=
b] python-ironic-lib: Fails to build source after successful build
Unarchived Bug 1048056
> unarchive 1048066
Bug #1048066 {Done: A. Maitland Bottoms <bottoms@debian.org>} [src:log4cpp]=
 log4cpp: Fails to build source after successful build
Unarchived Bug 1048066
> unarchive 1048082
Bug #1048082 {Done: Chris Lamb <lamby@debian.org>} [src:libfiu] libfiu: Fai=
ls to build source after successful build
Unarchived Bug 1048082
> unarchive 1048091
Bug #1048091 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-bootstrap] python-xstatic-angular-bootstrap: Fails to build source a=
fter successful build
Unarchived Bug 1048091
> unarchive 1048114
Bug #1048114 {Done: Xiyue Deng <manphiz@gmail.com>} [src:muse-el] muse-el: =
Fails to build source after successful build
Unarchived Bug 1048114
> unarchive 1048134
Bug #1048134 {Done: Thomas Goirand <zigo@debian.org>} [src:python-jsonpath-=
rw] python-jsonpath-rw: Fails to build source after successful build
Unarchived Bug 1048134
> unarchive 1048141
Bug #1048141 {Done: Fabian Gr=C3=BCnbichler <debian@fabian.gruenbichler.ema=
il>} [src:rustc] rustc: Fails to build source after successful build
Unarchived Bug 1048141
> unarchive 1048142
Bug #1048142 {Done: Thomas Goirand <zigo@debian.org>} [src:watcher] watcher=
: Fails to build source after successful build
Unarchived Bug 1048142
> unarchive 1048154
Bug #1048154 {Done: Roland Mas <lolando@debian.org>} [src:jupyterhub] jupyt=
erhub: Fails to build source after successful build
Unarchived Bug 1048154
> unarchive 1048157
Bug #1048157 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-d=
agre-d3] python-xstatic-dagre-d3: Fails to build source after successful bu=
ild
Unarchived Bug 1048157
> unarchive 1048161
Bug #1048161 {Done: Gunnar Hjalmarsson <gunnarhj@debian.org>} [src:ibus-inp=
ut-pad] ibus-input-pad: Fails to build source after successful build
Unarchived Bug 1048161
> unarchive 1048175
Bug #1048175 {Done: Thomas Goirand <zigo@debian.org>} [src:octavia] octavia=
: Fails to build source after successful build
Unarchived Bug 1048175
> unarchive 1048179
Bug #1048179 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-b=
ootswatch] python-xstatic-bootswatch: Fails to build source after successfu=
l build
Unarchived Bug 1048179
> unarchive 1048182
Bug #1048182 {Done: Martin <debacle@debian.org>} [src:libxeddsa] libxeddsa:=
 Fails to build source after successful build
Unarchived Bug 1048182
> unarchive 1048183
Bug #1048183 {Done: Anibal Monsalve Salazar <anibal@debian.org>} [src:nfs4-=
acl-tools] nfs4-acl-tools: Fails to build source after successful build
Unarchived Bug 1048183
> unarchive 1048187
Bug #1048187 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-bgpvp=
n] networking-bgpvpn: Fails to build source after successful build
Unarchived Bug 1048187
> unarchive 1048192
Bug #1048192 {Done: Vagrant Cascadian <vagrant@debian.org>} [src:lcrq] lcrq=
: Fails to build source after successful build
Unarchived Bug 1048192
> unarchive 1048194
Bug #1048194 {Done: Thomas Goirand <zigo@debian.org>} [src:python-monascacl=
ient] python-monascaclient: Fails to build source after successful build
Unarchived Bug 1048194
> unarchive 1048215
Bug #1048215 {Done: Thomas Goirand <zigo@debian.org>} [src:python-tosca-par=
ser] python-tosca-parser: Fails to build source after successful build
Unarchived Bug 1048215
> unarchive 1048218
Bug #1048218 {Done: Thomas Goirand <zigo@debian.org>} [src:python-troveclie=
nt] python-troveclient: Fails to build source after successful build
Unarchived Bug 1048218
> unarchive 1048219
Bug #1048219 {Done: Thomas Goirand <zigo@debian.org>} [src:python-searchlig=
htclient] python-searchlightclient: Fails to build source after successful =
build
Unarchived Bug 1048219
> unarchive 1048225
Bug #1048225 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:mrc]=
 mrc: Fails to build source after successful build
Unarchived Bug 1048225
> unarchive 1048236
Bug #1048236 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-o=
bjectpath] python-xstatic-objectpath: Fails to build source after successfu=
l build
Unarchived Bug 1048236
> unarchive 1048256
Bug #1048256 {Done: Thomas Goirand <zigo@debian.org>} [src:mistral] mistral=
: Fails to build source after successful build
Unarchived Bug 1048256
> unarchive 1048262
Bug #1048262 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xvfbwrapp=
er] python-xvfbwrapper: Fails to build source after successful build
Unarchived Bug 1048262
> unarchive 1048274
Bug #1048274 {Done: Emmanuel Arias <eamanu@debian.org>} [src:python-plaster=
-pastedeploy] python-plaster-pastedeploy: Fails to build source after succe=
ssful build
Unarchived Bug 1048274
> unarchive 1048286
Bug #1048286 {Done: Thomas Goirand <zigo@debian.org>} [src:ironic-tempest-p=
lugin] ironic-tempest-plugin: Fails to build source after successful build
Unarchived Bug 1048286
> unarchive 1048287
Bug #1048287 {Done: Tommi H=C3=B6yn=C3=A4l=C3=A4nmaa <tommi.hoynalanmaa@iki=
.fi>} [src:theme-d] theme-d: Fails to build source after successful build
Unarchived Bug 1048287
> unarchive 1048301
Bug #1048301 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-f=
ont-awesome] python-xstatic-font-awesome: Fails to build source after succe=
ssful build
Unarchived Bug 1048301
> unarchive 1048337
Bug #1048337 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-brick]=
 python-os-brick: Fails to build source after successful build
Unarchived Bug 1048337
> unarchive 1048352
Bug #1048352 {Done: Thomas Goirand <zigo@debian.org>} [src:python-octaviacl=
ient] python-octaviaclient: Fails to build source after successful build
Unarchived Bug 1048352
> unarchive 1048374
Bug #1048374 {Done: Georges Khaznadar <georgesk@debian.org>} [src:m2l-pyqt]=
 m2l-pyqt: Fails to build source after successful build
Unarchived Bug 1048374
> unarchive 1048388
Bug #1048388 {Done: Thomas Goirand <zigo@debian.org>} [src:neutron-taas] ne=
utron-taas: Fails to build source after successful build
Unarchived Bug 1048388
> unarchive 1048393
Bug #1048393 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:pirs] =
pirs: Fails to build source after successful build
Unarchived Bug 1048393
> unarchive 1048396
> unarchive 1048405
Bug #1048405 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ddt] pyth=
on-ddt: Fails to build source after successful build
Unarchived Bug 1048405
> unarchive 1048416
Bug #1048416 {Done: Thomas Goirand <zigo@debian.org>} [src:neutron] neutron=
: Fails to build source after successful build
Unarchived Bug 1048416
> unarchive 1048418
Bug #1048418 {Done: Thomas Goirand <zigo@debian.org>} [src:python-calmjs.ty=
pes] python-calmjs.types: Fails to build source after successful build
Unarchived Bug 1048418
> unarchive 1048426
Bug #1048426 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslotest]=
 python-oslotest: Fails to build source after successful build
Unarchived Bug 1048426
> unarchive 1048427
Bug #1048427 {Done: Jonas Smedegaard <dr@jones.dk>} [src:sccache] sccache: =
Fails to build source after successful build
Unarchived Bug 1048427
> unarchive 1048428
Bug #1048428 {Done: Thomas Goirand <zigo@debian.org>} [src:keystone-tempest=
-plugin] keystone-tempest-plugin: Fails to build source after successful bu=
ild
Unarchived Bug 1048428
> unarchive 1048440
Bug #1048440 {Done: Thomas Goirand <zigo@debian.org>} [src:python-glance-st=
ore] python-glance-store: Fails to build source after successful build
Unarchived Bug 1048440
> unarchive 1048443
Bug #1048443 {Done: Pierre Gruet <pgt@debian.org>} [src:igv] igv: Fails to =
build source after successful build
Unarchived Bug 1048443
> unarchive 1048472
Bug #1048472 {Done: Thorsten Alteholz <debian@alteholz.de>} [src:osmo-trx] =
osmo-trx: Fails to build source after successful build
Unarchived Bug 1048472
> unarchive 1048476
Bug #1048476 {Done: Thomas Goirand <zigo@debian.org>} [src:octavia-dashboar=
d] octavia-dashboard: Fails to build source after successful build
Unarchived Bug 1048476
> unarchive 1048486
Bug #1048486 {Done: Thomas Goirand <zigo@debian.org>} [src:python-seamicroc=
lient] python-seamicroclient: Fails to build source after successful build
Unarchived Bug 1048486
> unarchive 1048503
Bug #1048503 {Done: Thomas Goirand <zigo@debian.org>} [src:python-masakaric=
lient] python-masakariclient: Fails to build source after successful build
Unarchived Bug 1048503
> unarchive 1048510
Bug #1048510 {Done: Andreas Tille <tille@debian.org>} [src:python-skbio] py=
thon-skbio: Fails to build source after successful build
Unarchived Bug 1048510
> unarchive 1048514
Bug #1048514 {Done: Thomas Goirand <zigo@debian.org>} [src:python-scciclien=
t] python-scciclient: Fails to build source after successful build
Unarchived Bug 1048514
> unarchive 1048539
Bug #1048539 {Done: Thomas Goirand <zigo@debian.org>} [src:python-watchercl=
ient] python-watcherclient: Fails to build source after successful build
Unarchived Bug 1048539
> unarchive 1048580
Bug #1048580 {Done: Ole Streicher <olebole@debian.org>} [src:photutils] pho=
tutils: Fails to build source after successful build
Unarchived Bug 1048580
> unarchive 1048599
Bug #1048599 {Done: Julien Puydt <jpuydt@debian.org>} [src:mathcomp-multino=
mials] mathcomp-multinomials: Fails to build source after successful build
Unarchived Bug 1048599
> unarchive 1048605
Bug #1048605 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-client=
-config] python-os-client-config: Fails to build source after successful bu=
ild
Unarchived Bug 1048605
> unarchive 1048625
Bug #1048625 {Done: Andrej Shadura <andrewsh@debian.org>} [src:pseudo] pseu=
do: Fails to build source after successful build
Unarchived Bug 1048625
> unarchive 1048629
Bug #1048629 {Done: Drew Parsons <dparsons@debian.org>} [src:netgen] netgen=
: Fails to build source after successful build
Unarchived Bug 1048629
> unarchive 1048647
Bug #1048647 {Done: ChangZhuo Chen (=E9=99=B3=E6=98=8C=E5=80=AC) <czchen@de=
bian.org>} [src:libfm] libfm: Fails to build source after successful build
Unarchived Bug 1048647
> unarchive 1048652
Bug #1048652 {Done: Timo Aaltonen <tjaalton@debian.org>} [src:vulkan-loader=
] vulkan-loader: Fails to build source after successful build
Unarchived Bug 1048652
> unarchive 1048685
Bug #1048685 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pydotplus=
] python-pydotplus: Fails to build source after successful build
Unarchived Bug 1048685
> unarchive 1048692
Bug #1048692 {Done: Christian Marillat <marillat@debian.org>} [src:libtorre=
nt-rasterbar] libtorrent-rasterbar: Fails to build source after successful =
build
Unarchived Bug 1048692
> unarchive 1048709
Bug #1048709 {Done: Thomas Goirand <zigo@debian.org>} [src:python-manilacli=
ent] python-manilaclient: Fails to build source after successful build
Unarchived Bug 1048709
> unarchive 1048725
Bug #1048725 {Done: Andreas Tille <tille@debian.org>} [src:python-http-pars=
er] python-http-parser: Fails to build source after successful build
Unarchived Bug 1048725
> unarchive 1048743
Bug #1048743 {Done: Dmitry Shachnev <mitya57@debian.org>} [src:qtbase-opens=
ource-src] qtbase-opensource-src: Fails to build source after successful bu=
ild
Unarchived Bug 1048743
> unarchive 1048747
Bug #1048747 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-fileupload] python-xstatic-angular-fileupload: Fails to build source=
 after successful build
Unarchived Bug 1048747
> unarchive 1048752
Bug #1048752 {Done: Mateusz =C5=81ukasik <mati75@linuxmint.pl>} [src:obconf=
] obconf: Fails to build source after successful build
Unarchived Bug 1048752
> unarchive 1048754
Bug #1048754 {Done: Michael Tokarev <mjt@tls.msk.ru>} [src:samba] samba: Fa=
ils to build source after successful build
Unarchived Bug 1048754
> unarchive 1048756
Bug #1048756 {Done: Timo R=C3=B6hling <roehling@debian.org>} [src:unicorn-e=
ngine] unicorn-engine: Fails to build source after successful build
Unarchived Bug 1048756
> unarchive 1048765
Bug #1048765 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-bagpi=
pe] networking-bagpipe: Fails to build source after successful build
Unarchived Bug 1048765
> unarchive 1048778
Bug #1048778 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-m=
agic-search] python-xstatic-magic-search: Fails to build source after succe=
ssful build
Unarchived Bug 1048778
> unarchive 1048798
Bug #1048798 {Done: Juli=C3=A1n Moreno Pati=C3=B1o <julian@debian.org>} [sr=
c:texmaker] texmaker: Fails to build source after successful build
Unarchived Bug 1048798
> unarchive 1048810
Bug #1048810 {Done: Gianfranco Costamagna <locutusofborg@debian.org>} [src:=
python-vulndb] python-vulndb: Fails to build source after successful build
Unarchived Bug 1048810
> unarchive 1048819
Bug #1048819 {Done: Thomas Goirand <zigo@debian.org>} [src:sixer] sixer: Fa=
ils to build source after successful build
Unarchived Bug 1048819
> unarchive 1048850
Bug #1048850 {Done: Thomas Goirand <zigo@debian.org>} [src:python-hacking] =
python-hacking: Fails to build source after successful build
Unarchived Bug 1048850
> unarchive 1048854
Bug #1048854 {Done: Thomas Goirand <zigo@debian.org>} [src:pyroute2] pyrout=
e2: Fails to build source after successful build
Unarchived Bug 1048854
> unarchive 1048856
Bug #1048856 {Done: Georges Khaznadar <georgesk@debian.org>} [src:pampi] pa=
mpi: Fails to build source after successful build
Unarchived Bug 1048856
> unarchive 1048907
Bug #1048907 {Done: Hilko Bengen <bengen@debian.org>} [src:supermin] superm=
in: Fails to build source after successful build
Unarchived Bug 1048907
> unarchive 1048912
Bug #1048912 {Done: Anton Gladky <gladk@debian.org>} [src:pyftdi] pyftdi: F=
ails to build source after successful build
Unarchived Bug 1048912
> unarchive 1048932
Bug #1048932 {Done: Scott Kitterman <scott@kitterman.com>} [src:pyspf] pysp=
f: Fails to build source after successful build
Unarchived Bug 1048932
> unarchive 1048936
Bug #1048936 {Done: Antonio Terceiro <terceiro@debian.org>} [src:passenger]=
 passenger: Fails to build source after successful build
Unarchived Bug 1048936
> unarchive 1048943
Bug #1048943 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.cont=
ext] python-oslo.context: Fails to build source after successful build
Unarchived Bug 1048943
> unarchive 1048944
Bug #1048944 {Done: Michael R. Crusoe <crusoe@debian.org>} [src:typeshed] t=
ypeshed: Fails to build source after successful build
Unarchived Bug 1048944
> unarchive 1048948
Bug #1048948 {Done: Mike Gabriel <sunweaver@debian.org>} [src:x2goclient] x=
2goclient: Fails to build source after successful build
Unarchived Bug 1048948
> unarchive 1048957
Bug #1048957 {Done: Thomas Goirand <zigo@debian.org>} [src:python-blazarcli=
ent] python-blazarclient: Fails to build source after successful build
Unarchived Bug 1048957
> unarchive 1048972
Bug #1048972 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.repo=
rts] python-oslo.reports: Fails to build source after successful build
Unarchived Bug 1048972
> unarchive 1048988
Bug #1048988 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-l2gw]=
 networking-l2gw: Fails to build source after successful build
Unarchived Bug 1048988
> unarchive 1048995
Bug #1048995 {Done: Thomas Goirand <zigo@debian.org>} [src:python-aodhclien=
t] python-aodhclient: Fails to build source after successful build
Unarchived Bug 1048995
> unarchive 1049005
Bug #1049005 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-h=
ogan] python-xstatic-hogan: Fails to build source after successful build
Unarchived Bug 1049005
> unarchive 1049006
Bug #1049006 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-vif] p=
ython-os-vif: Fails to build source after successful build
Unarchived Bug 1049006
> unarchive 1049009
Bug #1049009 {Done: Thomas Goirand <zigo@debian.org>} [src:python-castellan=
] python-castellan: Fails to build source after successful build
Unarchived Bug 1049009
> unarchive 1049013
Bug #1049013 {Done: Phil Wyett <philip.wyett@kathenas.org>} [src:sep] sep: =
Fails to build source after successful build
Unarchived Bug 1049013
> unarchive 1049029
Bug #1049029 {Done: Christian Kastner <ckk@debian.org>} [src:rocfft] rocfft=
: Fails to build source after successful build
Unarchived Bug 1049029
> unarchive 1049042
Bug #1049042 {Done: Thomas Goirand <zigo@debian.org>} [src:python-monasca-s=
tatsd] python-monasca-statsd: Fails to build source after successful build
Unarchived Bug 1049042
> unarchive 1049043
Bug #1049043 {Done: Georges Khaznadar <georgesk@debian.org>} [src:partclone=
] partclone: Fails to build source after successful build
Unarchived Bug 1049043
> unarchive 1049051
Bug #1049051 {Done: Thomas Goirand <zigo@debian.org>} [src:mistral-dashboar=
d] mistral-dashboard: Fails to build source after successful build
Unarchived Bug 1049051
> unarchive 1049053
Bug #1049053 {Done: Thomas Goirand <zigo@debian.org>} [src:masakari] masaka=
ri: Fails to build source after successful build
Unarchived Bug 1049053
> unarchive 1049054
Bug #1049054 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-cookies] python-xstatic-angular-cookies: Fails to build source after=
 successful build
Unarchived Bug 1049054
> unarchive 1049076
Bug #1049076 {Done: Tormod Volden <debian.tormod@gmail.com>} [src:xscreensa=
ver] xscreensaver: Fails to build source after successful build
Unarchived Bug 1049076
> unarchive 1049109
Bug #1049109 {Done: Philip Hands <phil@hands.com>} [src:openqa] openqa: Fai=
ls to build source after successful build
Unarchived Bug 1049109
> unarchive 1049125
Bug #1049125 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query.bootstrap.wizard] python-xstatic-jquery.bootstrap.wizard: Fails to bu=
ild source after successful build
Unarchived Bug 1049125
> unarchive 1049163
Bug #1049163 {Done: Thomas Goirand <zigo@debian.org>} [src:trove-dashboard]=
 trove-dashboard: Fails to build source after successful build
Unarchived Bug 1049163
> unarchive 1049177
Bug #1049177 {Done: Andrej Shadura <andrewsh@debian.org>} [src:lavacli] lav=
acli: Fails to build source after successful build
Unarchived Bug 1049177
> unarchive 1049189
Bug #1049189 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-ui-router] python-xstatic-angular-ui-router: Fails to build source a=
fter successful build
Unarchived Bug 1049189
> unarchive 1049198
Bug #1049198 {Done: Dmitry Shachnev <mitya57@debian.org>} [src:qtbase-opens=
ource-src-gles] qtbase-opensource-src-gles: Fails to build source after suc=
cessful build
Unarchived Bug 1049198
> unarchive 1049216
Bug #1049216 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-g=
raphlib] python-xstatic-graphlib: Fails to build source after successful bu=
ild
Unarchived Bug 1049216
> unarchive 1049217
Bug #1049217 {Done: Thomas Goirand <zigo@debian.org>} [src:placement] place=
ment: Fails to build source after successful build
Unarchived Bug 1049217
> unarchive 1049230
Bug #1049230 {Done: St=C3=A9phane Glondu <glondu@debian.org>} [src:ocaml] o=
caml: Fails to build source after successful build
Unarchived Bug 1049230
> unarchive 1049233
Bug #1049233 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-schema-form] python-xstatic-angular-schema-form: Fails to build sour=
ce after successful build
Unarchived Bug 1049233
> unarchive 1049242
Bug #1049242 {Done: Pierre Neyron <pierre.neyron@free.fr>} [src:oar] oar: F=
ails to build source after successful build
Unarchived Bug 1049242
> unarchive 1049246
Bug #1049246 {Done: Carsten Schoenert <c.schoenert@t-online.de>} [src:psyco=
pg3] psycopg3: Fails to build source after successful build
Unarchived Bug 1049246
> unarchive 1049262
Bug #1049262 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
s-yaml] python-xstatic-js-yaml: Fails to build source after successful build
Unarchived Bug 1049262
> unarchive 1049271
Bug #1049271 {Done: Ole Streicher <olebole@debian.org>} [src:saods9] saods9=
: Fails to build source after successful build
Unarchived Bug 1049271
> unarchive 1049288
Bug #1049288 {Done: Thomas Goirand <zigo@debian.org>} [src:python-automaton=
] python-automaton: Fails to build source after successful build
Unarchived Bug 1049288
> unarchive 1049293
Bug #1049293 {Done: Reinhard Tartler <siretart@tauware.de>} [src:notary] no=
tary: Fails to build source after successful build
Unarchived Bug 1049293
> unarchive 1049307
Bug #1049307 {Done: Thomas Goirand <zigo@debian.org>} [src:python-sphinx-fe=
ature-classification] python-sphinx-feature-classification: Fails to build =
source after successful build
Unarchived Bug 1049307
> unarchive 1049315
Bug #1049315 {Done: Bdale Garbee <bdale@gag.com>} [src:librnd] librnd: Fail=
s to build source after successful build
Unarchived Bug 1049315
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1043628: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043628
1043642: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043642
1043647: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043647
1043650: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043650
1043669: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043669
1043679: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043679
1043705: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043705
1043723: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043723
1043725: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043725
1043738: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043738
1043780: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043780
1043791: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043791
1043815: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043815
1043846: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043846
1043853: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043853
1043859: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043859
1043875: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043875
1043877: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043877
1043897: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043897
1043901: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043901
1043919: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043919
1043920: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043920
1043921: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043921
1043955: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043955
1043959: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043959
1043960: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043960
1043963: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043963
1043989: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043989
1044007: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044007
1044015: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044015
1044018: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044018
1044020: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044020
1044022: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044022
1044028: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044028
1044048: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044048
1044090: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044090
1044094: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044094
1044095: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044095
1044103: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044103
1044141: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044141
1044144: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044144
1044156: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044156
1044166: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044166
1044194: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044194
1044205: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044205
1044207: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044207
1044239: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044239
1044249: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044249
1044251: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044251
1044253: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044253
1044268: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044268
1044278: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044278
1044302: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044302
1044439: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044439
1044442: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044442
1044447: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044447
1044462: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044462
1044465: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044465
1044486: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044486
1044510: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044510
1044511: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044511
1044550: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044550
1044584: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044584
1044591: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044591
1044593: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044593
1044630: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044630
1044632: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044632
1044633: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044633
1044637: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044637
1044642: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044642
1044649: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044649
1044654: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044654
1044666: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044666
1044720: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044720
1044740: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044740
1044796: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044796
1044825: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044825
1044832: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044832
1044858: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044858
1044859: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044859
1044886: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044886
1044901: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044901
1044915: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044915
1044922: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044922
1044936: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044936
1044979: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044979
1044981: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044981
1044991: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044991
1044992: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044992
1045029: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045029
1045047: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045047
1045073: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045073
1045076: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045076
1045085: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045085
1045093: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045093
1045122: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045122
1045142: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045142
1045150: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045150
1045152: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045152
1045153: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045153
1045155: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045155
1045158: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045158
1045170: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045170
1045186: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045186
1045198: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045198
1045199: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045199
1045213: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045213
1045222: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045222
1045244: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045244
1045267: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045267
1045272: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045272
1045282: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045282
1045286: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045286
1045300: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045300
1045311: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045311
1045316: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045316
1045355: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045355
1045357: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045357
1045364: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045364
1045366: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045366
1045381: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045381
1045383: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045383
1045393: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045393
1045395: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045395
1045407: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045407
1045412: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045412
1045430: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045430
1045440: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045440
1045450: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045450
1045481: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045481
1045487: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045487
1045493: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045493
1045510: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045510
1045515: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045515
1045526: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045526
1045535: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045535
1045566: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045566
1045567: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045567
1045587: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045587
1045609: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045609
1045611: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045611
1045615: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045615
1045618: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045618
1045619: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045619
1045639: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045639
1045642: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045642
1045651: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045651
1045653: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045653
1045662: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045662
1045672: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045672
1045678: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045678
1045694: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045694
1045706: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045706
1045710: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045710
1045716: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045716
1045732: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045732
1045748: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045748
1045749: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045749
1045759: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045759
1045761: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045761
1045771: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045771
1045774: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045774
1045791: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045791
1045808: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045808
1045814: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045814
1045818: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045818
1045822: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045822
1045869: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045869
1045872: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045872
1045877: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045877
1045897: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045897
1045916: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045916
1045926: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045926
1045932: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045932
1045942: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045942
1045949: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045949
1045954: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045954
1045967: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045967
1045968: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045968
1045981: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045981
1045986: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045986
1045988: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045988
1046018: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046018
1046021: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046021
1046082: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046082
1046090: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046090
1046108: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046108
1046125: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046125
1046156: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046156
1046167: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046167
1046169: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046169
1046172: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046172
1046175: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046175
1046176: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046176
1046201: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046201
1046221: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046221
1046222: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046222
1046233: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046233
1046238: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046238
1046253: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046253
1046271: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046271
1046273: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046273
1046279: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046279
1046280: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046280
1046283: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046283
1046287: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046287
1046290: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046290
1046291: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046291
1046302: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046302
1046311: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046311
1046323: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046323
1046350: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046350
1046363: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046363
1046372: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046372
1046388: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046388
1046396: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046396
1046402: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046402
1046403: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046403
1046416: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046416
1046430: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046430
1046444: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046444
1046450: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046450
1046451: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046451
1046452: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046452
1046459: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046459
1046467: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046467
1046493: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046493
1046499: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046499
1046505: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046505
1046512: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046512
1046528: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046528
1046531: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046531
1046536: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046536
1046543: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046543
1046551: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046551
1046552: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046552
1046557: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046557
1046561: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046561
1046565: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046565
1046569: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046569
1046571: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046571
1046600: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046600
1046604: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046604
1046618: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046618
1046628: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046628
1046642: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046642
1046699: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046699
1046710: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046710
1046712: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046712
1046716: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046716
1046775: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046775
1046778: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046778
1046783: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046783
1046788: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046788
1046789: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046789
1046791: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046791
1046813: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046813
1046816: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046816
1046832: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046832
1046843: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046843
1046849: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046849
1046864: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046864
1046913: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046913
1046915: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046915
1046921: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046921
1046931: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046931
1046957: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046957
1046966: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046966
1046971: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046971
1046977: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046977
1046994: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046994
1046999: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046999
1047001: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047001
1047018: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047018
1047020: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047020
1047030: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047030
1047043: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047043
1047070: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047070
1047089: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047089
1047091: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047091
1047097: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047097
1047105: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047105
1047135: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047135
1047146: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047146
1047161: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047161
1047182: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047182
1047192: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047192
1047194: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047194
1047199: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047199
1047202: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047202
1047205: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047205
1047213: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047213
1047244: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047244
1047249: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047249
1047254: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047254
1047264: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047264
1047280: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047280
1047288: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047288
1047318: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047318
1047327: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047327
1047333: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047333
1047356: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047356
1047384: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047384
1047394: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047394
1047401: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047401
1047422: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047422
1047423: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047423
1047431: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047431
1047466: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047466
1047472: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047472
1047478: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047478
1047482: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047482
1047490: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047490
1047493: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047493
1047498: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047498
1047502: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047502
1047524: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047524
1047547: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047547
1047552: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047552
1047555: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047555
1047562: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047562
1047573: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047573
1047576: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047576
1047577: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047577
1047597: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047597
1047612: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047612
1047621: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047621
1047643: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047643
1047663: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047663
1047665: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047665
1047688: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047688
1047705: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047705
1047724: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047724
1047735: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047735
1047738: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047738
1047747: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047747
1047756: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047756
1047769: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047769
1047790: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047790
1047791: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047791
1047792: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047792
1047819: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047819
1047823: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047823
1047826: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047826
1047831: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047831
1047834: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047834
1047835: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047835
1047884: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047884
1047898: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047898
1047901: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047901
1047930: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047930
1047937: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047937
1047946: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047946
1047954: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047954
1047961: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047961
1047969: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047969
1048006: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048006
1048007: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048007
1048014: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048014
1048018: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048018
1048019: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048019
1048023: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048023
1048034: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048034
1048047: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048047
1048050: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048050
1048052: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048052
1048053: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048053
1048055: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048055
1048056: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048056
1048066: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048066
1048082: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048082
1048091: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048091
1048114: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048114
1048134: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048134
1048141: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048141
1048142: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048142
1048154: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048154
1048157: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048157
1048161: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048161
1048175: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048175
1048179: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048179
1048182: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048182
1048183: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048183
1048187: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048187
1048192: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048192
1048194: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048194
1048215: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048215
1048218: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048218
1048219: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048219
1048225: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048225
1048236: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048236
1048256: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048256
1048262: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048262
1048274: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048274
1048286: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048286
1048287: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048287
1048301: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048301
1048337: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048337
1048352: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048352
1048374: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048374
1048388: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048388
1048393: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048393
1048405: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048405
1048416: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048416
1048418: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048418
1048426: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048426
1048427: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048427
1048428: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048428
1048440: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048440
1048443: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048443
1048472: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048472
1048476: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048476
1048486: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048486
1048503: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048503
1048510: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048510
1048514: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048514
1048539: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048539
1048580: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048580
1048599: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048599
1048605: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048605
1048625: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048625
1048629: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048629
1048647: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048647
1048652: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048652
1048685: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048685
1048692: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048692
1048709: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048709
1048725: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048725
1048743: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048743
1048747: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048747
1048752: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048752
1048754: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048754
1048756: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048756
1048765: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048765
1048778: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048778
1048798: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048798
1048810: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048810
1048819: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048819
1048850: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048850
1048854: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048854
1048856: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048856
1048907: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048907
1048912: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048912
1048932: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048932
1048936: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048936
1048943: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048943
1048944: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048944
1048948: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048948
1048957: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048957
1048972: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048972
1048988: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048988
1048995: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048995
1049005: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049005
1049006: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049006
1049009: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049009
1049013: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049013
1049029: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049029
1049042: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049042
1049043: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049043
1049051: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049051
1049053: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049053
1049054: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049054
1049076: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049076
1049109: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049109
1049125: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049125
1049163: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049163
1049177: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049177
1049189: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049189
1049198: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049198
1049216: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049216
1049217: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049217
1049230: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049230
1049233: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049233
1049242: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049242
1049246: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049246
1049262: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049262
1049271: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049271
1049288: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049288
1049293: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049293
1049307: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049307
1049315: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049315
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems
