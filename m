Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5712D2FF14C
	for <linux-xfs@vger.kernel.org>; Tue,  3 Feb 2026 23:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770160084; cv=none; b=XXRC05vUZRfJDTc4R9p0voHRuY2q88j3xU38CNtCLzrrwir8OlFahA6lRstzlYNHsUZ18vbF5p5UX3bLto3U3eNwd8ipB1/87Pidd0uHFsEBmSSkVRclUnvFEGPbTzbHPUhT8bOJ0MaCdSrKPxvWCzFdBveMTvAol1iAkvgHyEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770160084; c=relaxed/simple;
	bh=S2kLkPXkc315mMGWlEvtLRy08VsrJQjTLpWrtP+Fbaw=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:CC:Subject:
	 Message-ID:References:Date; b=DIahci46HiwKjgO5MIO3ZcoHuVYgpJ4GqyJ5ylHwurqp3w40qLmp3HesphVkRBHrY8OMC6omYG1iQzRYzkFvjzeKURcMeftK7h/zDUInt9i3UK8EqlY+t+e3dZXeZ5+tHMmrk5FwDB2kiz7DZaLHOQtBP3TDCzHXb1IJjA9hsCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=MeBUAQRK; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="MeBUAQRK"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:References:Message-ID:Subject
	:CC:To:From:Content-Type:MIME-Version:Content-Transfer-Encoding:Reply-To:
	Content-ID:Content-Description:In-Reply-To;
	bh=S2kLkPXkc315mMGWlEvtLRy08VsrJQjTLpWrtP+Fbaw=; b=MeBUAQRKYhDHysJJv4QoXGwESk
	UmIAPjf032O7NjbyTukx+NpW9Yz1ktk+3y+cjPga2yIOGbvPAOk4ZPPQUZOXtmvzohdX+m8rRUeFK
	K3qQwiK46klnYgeR96XdY0rnWuh7HJZrA6WmwRuDwexdw+rBLbJYpnH9HYUt1XGgQkvthodZxqAgO
	K5d3JceVfI6GlwZQrUsPfRwZ2J/rR/EPFL4SnU0FESNinPlXliZFmGxj3A3DJW3tQmr/5M2snO8cc
	CAilyHisZw+HXVlUHJ+P20j43i0tLUzMNu2+A4Sc4cFhJYbtKWY0Db9+RaGkI0j2z8/7xFwZZKjbY
	mUUARNBw==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.96)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1vnPST-003xAz-0E;
	Tue, 03 Feb 2026 23:05:21 +0000
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
CC: debian-pan-maintainers@alioth-lists.debian.net,
 pkg-rust-maintainers@alioth-lists.debian.net, gpsbabel@packages.debian.org,
 post@rolandgruber.de, dkogan@debian.org, dr@jones.dk,
 debian-lego-team@lists.alioth.debian.org, bage@debian.org, phil@hands.com,
 pkg-games-devel@lists.alioth.debian.org,
 debian-astro-maintainers@alioth-lists.debian.net,
 debian-emacsen@lists.debian.org, vv221@debian.org, georgesk@debian.org,
 team+lxde@tracker.debian.org, pkg-freeipa-devel@alioth-lists.debian.net,
 fungi@yuggoth.org, andrewsh@debian.org,
 pkg-electronics-devel@alioth-lists.debian.net,
 pkg-ruby-extras-maintainers@lists.alioth.debian.org,
 debian.tormod@gmail.com, team+python@tracker.debian.org, bdale@gag.com,
 glaubitz@physik.fu-berlin.de, bottoms@debian.org,
 pkg-freeradius-maintainers@lists.alioth.debian.org, jpakkane@gmail.com,
 tchet@debian.org, tommi.hoynalanmaa@iki.fi,
 pkg-javascript-devel@alioth-lists.debian.net, debian@helgefjell.de,
 pkg-rakudo-devel@lists.alioth.debian.org,
 debian-input-method@lists.debian.org, frankie@debian.org,
 linux-xfs@vger.kernel.org, team+clojure@tracker.debian.org,
 pmatthaei@debian.org, r-pkg-team@alioth-lists.debian.net,
 debian-ocaml-maint@lists.debian.org, scott@kitterman.com,
 roehling@debian.org, sten@debian.org, mmyangfl@gmail.com,
 rousseau@debian.org, mckinstry@debian.org,
 pkg-sdl-maintainers@lists.alioth.debian.org,
 pkg-request-tracker-maintainers@lists.alioth.debian.org,
 ar.manuelguerra@gmail.com, f.b.brokken@rug.nl, gabriel@debian.org,
 emc-developers@lists.sourceforge.net, jamessan@debian.org,
 pkg-dpdk-devel@lists.alioth.debian.org,
 debian-ha-maintainers@lists.alioth.debian.org, sthibault@debian.org,
 atzlinux@sina.com, debian-astro-maintainers@lists.alioth.debian.org,
 debian-astro-maintainers@lists.alioth.debian.org,
 pkg-linaro-lava-devel@lists.alioth.debian.org,
 pkg-xmpp-devel@lists.alioth.debian.org, team+pkg-go@tracker.debian.org,
 pcp@groups.io, agmartin@debian.org, maxy@debian.org,
 pkg-samba-maint@lists.alioth.debian.org, mati75@linuxmint.pl,
 pkg-libvirt-maintainers@lists.alioth.debian.org, bzed@debian.org,
 lamby@debian.org, guilhem@debian.org, team+pkg-security@tracker.debian.org,
 gspr@nonempty.org, bigon@debian.org,
 debian-xml-sgml-pkgs@lists.alioth.debian.org, pierre.neyron@free.fr,
 team+postgresql@tracker.debian.org, debian-tex-maint@lists.debian.org,
 team+openstack@tracker.debian.org, pkg-lua-devel@lists.alioth.debian.org,
 joodebian@joonet.de, team+salvage@tracker.debian.org, valhalla@debian.org,
 roam@debian.org, christsc@gmx.de, tom@cryptography.ch, marillat@debian.org,
 debian-science-maintainers@lists.alioth.debian.org,
 pkg-deepin-devel@lists.alioth.debian.org,
 debian-med-packaging@lists.alioth.debian.org,
 debichem-devel@lists.alioth.debian.org,
 pkg-javascript-devel@lists.alioth.debian.org,
 pkg-pascal-devel@lists.alioth.debian.org, debian-remote@lists.debian.org,
 daniel@debian.org, debian-x@lists.debian.org,
 pkg-electronics-devel@lists.alioth.debian.org, jcfp@debian.org,
 pkg-matrix-maintainers@lists.alioth.debian.org, fsfs@debian.org,
 debian-qt-kde@lists.debian.org, anibal@debian.org,
 debian-science-maintainers@alioth-lists.debian.net, serpent@debian.org,
 bugs@hypra.fr, pkg-java-maintainers@lists.alioth.debian.org,
 francois@debian.org, debian@jff.email,
 Debian-mobcom-maintainers@lists.alioth.debian.org,
 debian-multimedia@lists.debian.org, team+pkg-rpm@tracker.debian.org,
 team+math@tracker.debian.org,
 debian-astro-maintainers@lists.alioth.debian.org
Subject: Processed: not fixed in trixie
Message-ID: <handler.s.C.1770159855942213.transcript@bugs.debian.org>
References: <aYJ-6wGgNbU7-L2A@nuc>
X-Debian-PR-Package: src:python-oslo.middleware src:kxd src:atool
 src:bladerf src:raphael src:pcp src:brian src:python-oslo.db
 src:designate-dashboard src:osmo-trx src:python-monascaclient
 src:python-xstatic-angular-schema-form src:ovn src:python-xstatic-angular-gettext
 src:angelscript src:pyspf src:python-automaton src:python-calmjs.parse
 src:sch-rnd src:neutron-tempest-plugin src:turing src:tortoize
 src:python-pyhcl src:mistral-tempest-plugin src:python-typepy
 src:networking-sfc src:python-os-refresh-config src:python-os-vif
 src:clonalframeml src:insighttoolkit5 src:cysignals src:libssh
 src:python-cursive src:oar src:fastml src:watcher src:python-xvfbwrapper
 src:ssl-utils-clojure src:python-xstatic-qunit src:vulkan-loader
 src:xfsprogs src:python-cryptography src:python-oslo.log src:log4cpp
 src:mistral src:octavia-dashboard src:samba src:coq-quickchick
 src:statsmodels src:ocaml-benchmark src:nmodl src:rust-ureq
 src:python-xstatic-moment src:python-zaqarclient src:manila-tempest-plugin
 src:python-xstatic-spin src:xmlsec1 src:heat-tempest-plugin
 src:os-autoinst src:cinder-tempest-plugin src:python-oslo.policy
 src:python-hdf5plugin src:python-octaviaclient src:healpy src:qtbase-opensource-src
 src:astrometry.net src:coffeescript src:zaqar-tempest-plugin
 src:nfs4-acl-tools src:python-xstatic-dagre src:dsh src:dnsjit
 src:python-glanceclient src:python-logutils src:manila src:texmaker
 src:heat src:python-django-pyscss src:python-bashate src:libdnf
 src:python-osprofiler src:python-numpysane src:python-wsme src:ecflow
 src:python-vulndb src:python-oslo.limit src:planets src:python-magnumclient
 src:python-xstatic-bootswatch src:python-kafka src:python-xstatic-dagre-d3
 src:re2c src:python-sphinxcontrib.apidoc src:python-wsgi-intercept
 src:libtorrent-rasterbar src:mpgrafic src:pyliblo src:python-debtcollector
 src:notion src:python-octavia-lib src:python-os-win src:gramadoir
 src:neuron src:python-xstatic-angular-mock src:python-pybedtools src:gajim
 src:python-xstatic-angular-uuid src:python-mrcfile src:gnuradio
 src:r-bioc-rhdf5filters src:enigma src:libfiu src:python-oslo.cache
 src:ironic-ui src:python-plaster-pastedeploy src:python-designateclient
 src:python-pydotplus src:python-os-testr src:python-requests-mock
 src:ceilometer-instance-poller src:mathcomp-multinomials src:iraf-rvsao
 src:pyscard src:dkimpy src:saods9 src:masakari-monitors src:python-xstatic-angular-cookies
 src:designate src:python-oslo.metrics src:masakari src:btrfs-progs
 src:python-xstatic-jquery-migrate src:ibus-table src:ironic-tempest-plugin
 src:python-aodhclient src:rabbitmq-server src:rustc src:python-ceilometermiddleware
 src:olm src:macs src:python-troveclient src:python-castellan src:psycopg3
 src:coq-interval src:sane-backends src:python-oslo.versionedobjects
 src:octavia-tempest-plugin src:neutron-taas src:python-cloudkittyclient
 src:python-fastbencode src:python-xstatic-font-awesome src:masakari-dashboard
 src:python-searchlightclient src:bali-phy src:ocaml src:biomaj3-download
 src:ssh-cron src:python-os-client-config src:h5z-zfp src:python-jsonpath-rw
 src:python-oslo.utils src:ivar src:yara src:tempest src:libsdl2-mixer
 src:designate-tempest-plugin src:python-tinyalign src:openstack-trove
 src:jellyfish1 src:python-json-patch src:python-pycadf src:python-xstatic-jsencrypt
 src:python-autobahn src:python-oslo.context src:coq-elpi src:sccache
 src:networking-bagpipe src:findimagedupes src:ring-clojure src:heat-dashboard
 src:librnd src:python-stestr src:python-xstatic-graphlib src:python-django-appconf
 src:pampi src:dpdk src:python-glance-store src:python-xstatic-bootstrap-datepicker
 src:xraylarch src:python-xstatic-angular-vis src:udm src:python-proliantutils
 src:linuxinfo src:python-seamicroclient src:python-osc-placement
 src:ldap-account-manager src:python-xstatic-jasmine src:typer src:dosage
 src:rime-cantonese src:python-keystonemiddleware src:theme-d
 src:python-pymemcache src:tempest-horizon src:zaqar src:python-xstatic-angular
 src:numpy src:python-ovsdbapp src:passenger src:rust-gping src:python-scciclient
 src:mira src:elektroid src:python-xstatic-roboto-fontface src:runc
 src:python-xstatic-filesaver src:poezio src:neutron-vpnaas-dashboard
 src:python-xstatic-jquery src:xfe src:scikit-learn src:python-xstatic-angular-ui-router
 src:muse-el src:weather-util src:python-barbicanclient src:coq-stdpp
 src:magnum src:sep src:python-os-brick src:as31 src:python-xstatic-angular-lrdragndrop
 src:python-termstyle src:python-xstatic src:python-ironic-inspector-client
 src:python-http-parser src:gcc-h8300-hms src:python-sushy src:python-os-traits
 src:igv src:gnome-shell-extensions-extra src:obconf src:libxeddsa
 src:cloudkitty-dashboard src:python-xstatic-js-yaml src:gtg-trace
 src:python-xstatic-angular-bootstrap src:python-xstatic-jquery-ui
 src:reprof src:python-json-pointer src:apvlv src:pyftdi src:python-memcache
 src:deepin-icon-theme src:x2goclient src:petsc4py src:rt-extension-jsgantt
 src:sixer src:python-oslo.messaging src:python-reno src:retroarch
 src:reproject src:python-xstatic-moment-timezone src:0ad src:xxdiff
 src:libtecla src:python-yappi src:astap src:python-pyghmi src:python-tosca-parser
 src:oscar src:librcsb-core-wrapper src:freeradius src:tinygltf
 src:placement src:mono src:neutron src:python-sphinx-feature-classification
 src:linuxcnc src:cinder src:python-ironic-lib src:eos-sdk src:python-infinity
 src:python-ddt src:trove-tempest-plugin src:mrc src:abcmidi
 src:python-marathon src:python-daemonize src:coq-equations src:python-openstacksdk
 src:python-xstatic-jquery.bootstrap.wizard src:python-xstatic-term.js
 src:ironic-inspector src:dicom3tools src:matplotlib src:cloudkitty-tempest-plugin
 src:glance src:python-xstatic-rickshaw src:python-xstatic-json2yaml
 src:coq src:python-tempestconf src:python-rfc3986 src:keystone-tempest-plugin
 src:lua5.1 src:python-manilaclient src:ispell-fo src:pirs src:python-fisx
 src:avldrums.lv2 src:libsimpleini src:freeipa src:libpqxx src:mypaint
 src:python-xstatic-tv4 src:vitrage-dashboard src:libqcow src:python-pyspike
 src:python-hpilo src:belenios src:r-cran-data.table src:gpicview
 src:qrisk2 src:python-xstatic-objectpath src:networking-l2gw src:pymatgen
 src:confget src:last-align src:pyerfa src:rt-extension-mergeusers
 src:libtommath src:magnum-tempest-plugin src:crmsh src:ibus-m17n
 src:python-xstatic-jquery.tablesorter src:healpix-java src:python-os-resource-classes
 src:giac src:python-neutronclient src:vitrage-tempest-plugin
 src:castle-game-engine src:ibus-input-pad src:python-oslo.reports
 src:python-oslo.service src:python-watcherclient src:notary src:typeshed
 src:certmonger src:gubbins src:clhep src:python-oslo.config
 src:open-vm-tools src:telemetry-tempest-plugin src:zaqar-ui src:lavacli
 src:python-ldappool src:openqa src:python-pykmip src:python-xstatic-hogan
 src:gpsbabel src:libervia-pubsub src:python-wsaccel src:libiio
 src:dropbear src:barbican-tempest-plugin src:python-dracclient src:expeyes
 src:python-os-service-types src:python-oslo.rootwrap src:fop
 src:watcher-tempest-plugin src:scolasync src:todoman src:python-xstatic-jquery.quicksearch
 src:python-dogpile.cache src:bash-completion src:python-xstatic-magic-search
 src:python-neutron-lib src:ccsm src:netgen src:silx src:networking-bgpvpn
 src:python-blazarclient src:artfastqgenerator src:cif-tools
 src:python-xstatic-angular-fileupload src:supermin src:pcb-rnd
 src:python-zake src:glance-tempest-plugin src:icmake src:cloudkitty
 src:python-validate-pyproject src:python-xstatic-lodash src:hypre
 src:python-mbstrdecoder src:trove-dashboard src:magnum-ui src:python-hacking
 src:dssp src:ironic src:python-yaql src:python-zunclient src:python-xstatic-bootstrap-scss
 src:meson src:xscreensaver src:libfm src:dnscap src:libpdb-redo
 src:qtfeedback-opensource-src src:python-masakariclient src:jupyterhub
 src:python-pbr src:qtbase-opensource-src-gles src:virtualjaguar
 src:python-fixtures src:python-rcssmin src:r-bioc-rhtslib src:ghmm
 src:gap-factint src:emscripten src:angband src:dtkgui src:clazy
 src:mistral-dashboard src:octavia src:macaulay2 src:vramsteg src:stimfit
 src:python-monasca-statsd src:gnome-pie src:python-calmjs.types
 src:snakemake src:bitshuffle src:sphinxcontrib-programoutput src:reprepro
 src:networking-baremetal src:fastnetmon src:bepasty src:watcher-dashboard
 src:python-keystoneclient src:scipy src:python-oslo.privsep
 src:python-xstatic-smart-table src:texstudio src:python-xstatic-mdi
 src:asymptote src:sphinxcontrib-pecanwsme src:python-oslo.vmware
 src:python-morph src:python-oslo.i18n src:python-oslotest src:subversion
X-Debian-PR-Source: 0ad abcmidi angband angelscript apvlv artfastqgenerator
 as31 astap astrometry.net asymptote atool avldrums.lv2 bali-phy
 barbican-tempest-plugin bash-completion belenios bepasty biomaj3-download
 bitshuffle bladerf brian btrfs-progs castle-game-engine ccsm
 ceilometer-instance-poller certmonger cif-tools cinder cinder-tempest-plugin
 clazy clhep clonalframeml cloudkitty cloudkitty-dashboard cloudkitty-tempest-plugin
 coffeescript confget coq coq-elpi coq-equations coq-interval
 coq-quickchick coq-stdpp crmsh cysignals deepin-icon-theme designate
 designate-dashboard designate-tempest-plugin dicom3tools dkimpy dnscap
 dnsjit dosage dpdk dropbear dsh dssp dtkgui ecflow elektroid emscripten
 enigma eos-sdk expeyes fastml fastnetmon findimagedupes fop freeipa
 freeradius gajim gap-factint gcc-h8300-hms ghmm giac glance
 glance-tempest-plugin gnome-pie gnome-shell-extensions-extra gnuradio
 gpicview gpsbabel gramadoir gtg-trace gubbins h5z-zfp healpix-java healpy
 heat heat-dashboard heat-tempest-plugin hypre ibus-input-pad ibus-m17n
 ibus-table icmake igv insighttoolkit5 iraf-rvsao ironic ironic-inspector
 ironic-tempest-plugin ironic-ui ispell-fo ivar jellyfish1 jupyterhub
 keystone-tempest-plugin kxd last-align lavacli ldap-account-manager libdnf
 libervia-pubsub libfiu libfm libiio libpdb-redo libpqxx libqcow
 librcsb-core-wrapper librnd libsdl2-mixer libsimpleini libssh libtecla
 libtommath libtorrent-rasterbar libxeddsa linuxcnc linuxinfo log4cpp
 lua5.1 macaulay2 macs magnum magnum-tempest-plugin magnum-ui manila
 manila-tempest-plugin masakari masakari-dashboard masakari-monitors
 mathcomp-multinomials matplotlib meson mira mistral mistral-dashboard
 mistral-tempest-plugin mono mpgrafic mrc muse-el mypaint netgen
 networking-bagpipe networking-baremetal networking-bgpvpn networking-l2gw
 networking-sfc neuron neutron neutron-taas neutron-tempest-plugin
 neutron-vpnaas-dashboard nfs4-acl-tools nmodl notary notion numpy oar
 obconf ocaml ocaml-benchmark octavia octavia-dashboard octavia-tempest-plugin
 olm open-vm-tools openqa openstack-trove os-autoinst oscar osmo-trx ovn
 pampi passenger pcb-rnd pcp petsc4py pirs placement planets poezio
 psycopg3 pyerfa pyftdi pyliblo pymatgen pyscard pyspf python-aodhclient
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
 python-neutron-lib python-neutronclient python-numpysane python-octavia-lib
 python-octaviaclient python-openstacksdk python-os-brick python-os-client-config
 python-os-refresh-config python-os-resource-classes python-os-service-types
 python-os-testr python-os-traits python-os-vif python-os-win
 python-osc-placement python-oslo.cache python-oslo.config python-oslo.context
 python-oslo.db python-oslo.i18n python-oslo.limit python-oslo.log
 python-oslo.messaging python-oslo.metrics python-oslo.middleware
 python-oslo.policy python-oslo.privsep python-oslo.reports python-oslo.rootwrap
 python-oslo.service python-oslo.utils python-oslo.versionedobjects
 python-oslo.vmware python-oslotest python-osprofiler python-ovsdbapp
 python-pbr python-plaster-pastedeploy python-proliantutils python-pybedtools
 python-pycadf python-pydotplus python-pyghmi python-pyhcl python-pykmip
 python-pymemcache python-pyspike python-rcssmin python-reno
 python-requests-mock python-rfc3986 python-scciclient python-seamicroclient
 python-searchlightclient python-sphinx-feature-classification
 python-sphinxcontrib.apidoc python-stestr python-sushy python-tempestconf
 python-termstyle python-tinyalign python-tosca-parser python-troveclient
 python-typepy python-validate-pyproject python-vulndb python-watcherclient
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
 raphael re2c reprepro reprof reproject retroarch rime-cantonese
 ring-clojure rt-extension-jsgantt rt-extension-mergeusers runc rust-gping
 rust-ureq rustc samba sane-backends saods9 sccache sch-rnd scikit-learn
 scipy scolasync sep silx sixer snakemake sphinxcontrib-pecanwsme
 sphinxcontrib-programoutput ssh-cron ssl-utils-clojure statsmodels stimfit
 subversion supermin telemetry-tempest-plugin tempest tempest-horizon
 texmaker texstudio theme-d tinygltf todoman tortoize trove-dashboard
 trove-tempest-plugin turing typer typeshed udm virtualjaguar
 vitrage-dashboard vitrage-tempest-plugin vramsteg vulkan-loader watcher
 watcher-dashboard watcher-tempest-plugin weather-util x2goclient xfe
 xfsprogs xmlsec1 xraylarch xscreensaver xxdiff yara zaqar zaqar-tempest-plugin
 zaqar-ui
X-Debian-PR-Message: transcript
X-Loop: owner@bugs.debian.org
Date: Tue, 03 Feb 2026 23:05:20 +0000

Processing commands for control@bugs.debian.org:

> # the following bugs are verified not to be fixed in trixie nor sid
> # this is to clear the fixed version in case it is the same as trixie
> notfixed 1046902 1.6.3-3.1
Bug #1046902 {Done: Santiago Vila <sanvila@debian.org>} [src:libtecla] libt=
ecla: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046902 to the same values=
 previously set
> notfixed 1048396 1609-1
Bug #1048396 {Done: Nilesh Patra <nilesh@debian.org>} [src:last-align] last=
-align: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048396 to the same values=
 previously set
> notfixed 1043628 0.7.0-final-1
Bug #1043628 {Done: xiao sheng wen <atzlinux@sina.com>} [src:apvlv] apvlv: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043628 to the same values=
 previously set
> notfixed 1043642 0.7.3-1
Bug #1043642 {Done: Dennis Braun <snd@debian.org>} [src:avldrums.lv2] avldr=
ums.lv2: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043642 to the same values=
 previously set
> notfixed 1043647 4.0-1
Bug #1043647 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:bali-p=
hy] bali-phy: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043647 to the same values=
 previously set
> notfixed 1043650 1.2.1-1
Bug #1043650 {Done: Elena Grandi <valhalla@debian.org>} [src:bepasty] bepas=
ty: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043650 to the same values=
 previously set
> notfixed 1043669 0.5.2-1
Bug #1043669 {Done: Picca Fr=C3=A9d=C3=A9ric-Emmanuel <picca@debian.org>} [=
src:bitshuffle] bitshuffle: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043669 to the same values=
 previously set
> notfixed 1043695 2.35.1+ds-3.1
Bug #1043695 {Done: Yangfl <mmyangfl@gmail.com>} [src:angelscript] angelscr=
ipt: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043695 to the same values=
 previously set
> notfixed 1043705 0.27.0-2
Bug #1043705 {Done: Vincent Cheng <vcheng@debian.org>} [src:0ad] 0ad: Fails=
 to build source after successful build
Ignoring request to alter fixed versions of bug #1043705 to the same values=
 previously set
> notfixed 1043723 1.17.0-2
Bug #1043723 {Done: Thomas Goirand <zigo@debian.org>} [src:cinder-tempest-p=
lugin] cinder-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043723 to the same values=
 previously set
> notfixed 1043725 3.0+dfsg-2
Bug #1043725 {Done: St=C3=A9phane Glondu <glondu@debian.org>} [src:belenios=
] belenios: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043725 to the same values=
 previously set
> notfixed 1043780 7.0~alpha.3+dfsg2-4
Bug #1043780 {Done: Abou Al Montacir <abou.almontacir@sfr.fr>} [src:castle-=
game-engine] castle-game-engine: Fails to build source after successful bui=
ld
Ignoring request to alter fixed versions of bug #1043780 to the same values=
 previously set
> notfixed 1043815 4.3.0-2
Bug #1043815 {Done: Thomas Goirand <zigo@debian.org>} [src:barbican-tempest=
-plugin] barbican-tempest-plugin: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1043815 to the same values=
 previously set
> notfixed 1043846 3.2.12-2
Bug #1043846 {Done: Andreas Tille <tille@debian.org>} [src:biomaj3-download=
] biomaj3-download: Fails to build source after successful build
No longer marked as fixed in versions biomaj3-download/3.2.12-2.
> notfixed 1043853 2.7.0+dfsg1-2
Bug #1043853 {Done: Yadd <yadd@debian.org>} [src:coffeescript] coffeescript=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043853 to the same values=
 previously set
> notfixed 1043859 1.0.0-2
Bug #1043859 {Done: Thomas Goirand <zigo@debian.org>} [src:ceilometer-insta=
nce-poller] ceilometer-instance-poller: Fails to build source after success=
ful build
Ignoring request to alter fixed versions of bug #1043859 to the same values=
 previously set
> notfixed 1043875 0.2024.05-1
Bug #1043875 {Done: A. Maitland Bottoms <bottoms@debian.org>} [src:bladerf]=
 bladerf: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043875 to the same values=
 previously set
> notfixed 1043877 2:0.8.18-5
Bug #1043877 {Done: Samuel Thibault <sthibault@debian.org>} [src:ccsm] ccsm=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043877 to the same values=
 previously set
> notfixed 1043897 1.0.12-4
Bug #1043897 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:cif-=
tools] cif-tools: Fails to build source after successful build
No longer marked as fixed in versions cif-tools/1.0.12-4.
> notfixed 1043901 2024.05.01-1
Bug #1043901 {Done: Thorsten Alteholz <debian@alteholz.de>} [src:astap] ast=
ap: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043901 to the same values=
 previously set
> notfixed 1043919 0.39.0-14
Bug #1043919 {Done: Francois Marier <francois@debian.org>} [src:atool] atoo=
l: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043919 to the same values=
 previously set
> notfixed 1043920 2.8.0.4-1
Bug #1043920 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:brian]=
 brian: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043920 to the same values=
 previously set
> notfixed 1043921 20.0.0-1
Bug #1043921 {Done: Thomas Goirand <zigo@debian.org>} [src:cloudkitty-dashb=
oard] cloudkitty-dashboard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043921 to the same values=
 previously set
> notfixed 1043955 20250216+ds-1
Bug #1043955 {Done: Dennis Braun <snd@debian.org>} [src:abcmidi] abcmidi: F=
ails to build source after successful build
Ignoring request to alter fixed versions of bug #1043955 to the same values=
 previously set
> notfixed 1043959 2.3.1-12
Bug #1043959 {Done: Bdale Garbee <bdale@gag.com>} [src:as31] as31: Fails to=
 build source after successful build
Ignoring request to alter fixed versions of bug #1043959 to the same values=
 previously set
> notfixed 1043960 0.0.20150519-5
Bug #1043960 {Done: Andreas Tille <tille@debian.org>} [src:artfastqgenerato=
r] artfastqgenerator: Fails to build source after successful build
No longer marked as fixed in versions artfastqgenerator/0.0.20150519-5.
> notfixed 1043963 1:4.2.5+dfsg1-3
Bug #1043963 {Done: Chris Carr <rantingman@gmail.com>} [src:angband] angban=
d: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043963 to the same values=
 previously set
> notfixed 1043989 22.0.0-2
Bug #1043989 {Done: Thomas Goirand <zigo@debian.org>} [src:cloudkitty] clou=
dkitty: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1043989 to the same values=
 previously set
> notfixed 1044007 6.14-1
Bug #1044007 {Done: Adam Borowski <kilobyte@angband.pl>} [src:btrfs-progs] =
btrfs-progs: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044007 to the same values=
 previously set
> notfixed 1044015 1.14-1
Bug #1044015 {Done: Pino Toscano <pino@debian.org>} [src:clazy] clazy: Fail=
s to build source after successful build
Ignoring request to alter fixed versions of bug #1044015 to the same values=
 previously set
> notfixed 1044018 3.2.0-2
Bug #1044018 {Done: Thomas Goirand <zigo@debian.org>} [src:cloudkitty-tempe=
st-plugin] cloudkitty-tempest-plugin: Fails to build source after successfu=
l build
Ignoring request to alter fixed versions of bug #1044018 to the same values=
 previously set
> notfixed 1044020 1.13-1
Bug #1044020 {Done: Andreas Tille <tille@debian.org>} [src:clonalframeml] c=
lonalframeml: Fails to build source after successful build
No longer marked as fixed in versions clonalframeml/1.13-1.
> notfixed 1044028 2:26.0.0-2
Bug #1044028 {Done: Thomas Goirand <zigo@debian.org>} [src:cinder] cinder: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044028 to the same values=
 previously set
> notfixed 1044048 0.79.20-2
Bug #1044048 {Done: Timo Aaltonen <tjaalton@debian.org>} [src:certmonger] c=
ertmonger: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044048 to the same values=
 previously set
> notfixed 1044090 3.02+ds-1
Bug #1044090 {Done: Hilmar Preusse <hille42@web.de>} [src:asymptote] asympt=
ote: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044090 to the same values=
 previously set
> notfixed 1044094 1:2.16.0-7
Bug #1044094 {Done: Gabriel F. T. Gomes <gabriel@debian.org>} [src:bash-com=
pletion] bash-completion: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044094 to the same values=
 previously set
> notfixed 1044103 0.97+dfsg-2
Bug #1044103 {Done: Ole Streicher <olebole@debian.org>} [src:astrometry.net=
] astrometry.net: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044103 to the same values=
 previously set
> notfixed 1044109 2.1.4.1+dfsg-1.2
Bug #1044109 {Done: Andreas Tille <tille@debian.org>} [src:clhep] clhep: Fa=
ils to build source after successful build
Ignoring request to alter fixed versions of bug #1044109 to the same values=
 previously set
> notfixed 1044141 0.3.1-1
Bug #1044141 {Done: ChangZhuo Chen (=E9=99=B3=E6=98=8C=E5=80=AC) <czchen@de=
bian.org>} [src:gpicview] gpicview: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1044141 to the same values=
 previously set
> notfixed 1044144 20250312-1
Bug #1044144 {Done: Daniel Baumann <daniel.baumann@progress-linux.org>} [sr=
c:gnome-shell-extensions-extra] gnome-shell-extensions-extra: Fails to buil=
d source after successful build
Ignoring request to alter fixed versions of bug #1044144 to the same values=
 previously set
> notfixed 1044156 1.6.3+ds-3
Bug #1044156 {Done: Jerome BENOIT <calculus@rezozer.net>} [src:gap-factint]=
 gap-factint: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044156 to the same values=
 previously set
> notfixed 1044166 1.30+dfsg-3
Bug #1044166 {Done: Alexandre Detiste <tchet@debian.org>} [src:enigma] enig=
ma: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044166 to the same values=
 previously set
> notfixed 1044194 0.12.0-2
Bug #1044194 {Done: Thomas Goirand <zigo@debian.org>} [src:glance-tempest-p=
lugin] glance-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044194 to the same values=
 previously set
> notfixed 1044205 2.20.1-3
Bug #1044205 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:findim=
agedupes] findimagedupes: Fails to build source after successful build
No longer marked as fixed in versions findimagedupes/2.20.1-3.
> notfixed 1044207 1.3.1-8.20-1
Bug #1044207 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-equations] c=
oq-equations: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044207 to the same values=
 previously set
> notfixed 1044239 13.0.0-1
Bug #1044239 {Done: Thomas Goirand <zigo@debian.org>} [src:heat-dashboard] =
heat-dashboard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044239 to the same values=
 previously set
> notfixed 1044249 1:24.0.0-2
Bug #1044249 {Done: Thomas Goirand <zigo@debian.org>} [src:heat] heat: Fail=
s to build source after successful build
Ignoring request to alter fixed versions of bug #1044249 to the same values=
 previously set
> notfixed 1044251 2.5.0-1.1
Bug #1044251 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-elpi] coq-el=
pi: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044251 to the same values=
 previously set
> notfixed 1044253 1.00~20240118131615-1
Bug #1044253 {Done: Andreas Tille <tille@debian.org>} [src:dicom3tools] dic=
om3tools: Fails to build source after successful build
No longer marked as fixed in versions dicom3tools/1.00~20240118131615-1.
> notfixed 1044302 5.0.0~rc1-1
Bug #1044302 {Done: Valentin Vidic <vvidic@debian.org>} [src:crmsh] crmsh: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044302 to the same values=
 previously set
> notfixed 1044439 3.10.12.0-1
Bug #1044439 {Done: A. Maitland Bottoms <bottoms@debian.org>} [src:gnuradio=
] gnuradio: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044439 to the same values=
 previously set
> notfixed 1044442 3.0+dfsg-2.1
Bug #1044442 {Done: Alexandre Detiste <tchet@debian.org>} [src:dosage] dosa=
ge: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044442 to the same values=
 previously set
> notfixed 1044447 3.60+ds-5
Bug #1044447 {Done: Phil Wyett <philip.wyett@kathenas.org>} [src:healpix-ja=
va] healpix-java: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044447 to the same values=
 previously set
> notfixed 1044462 0.7.3-2
Bug #1044462 {Done: J=C3=B6rg Frings-F=C3=BCrst <debian@jff.email>} [src:gn=
ome-pie] gnome-pie: Fails to build source after successful build
No longer marked as fixed in versions gnome-pie/0.7.3-2.
> notfixed 1044465 3.4-2
Bug #1044465 {Done: Andreas Tille <tille@debian.org>} [src:gubbins] gubbins=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044465 to the same values=
 previously set
> notfixed 1044486 1.12.3+ds-1
Bug #1044486 {Done: Jerome Benoit <calculus@rezozer.net>} [src:cysignals] c=
ysignals: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044486 to the same values=
 previously set
> notfixed 1044510 1.5.0-2
Bug #1044510 {Done: Daniel Baumann <daniel.baumann@progress-linux.org>} [sr=
c:dnsjit] dnsjit: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044510 to the same values=
 previously set
> notfixed 1044511 2.1.0-1
Bug #1044511 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-quickchick] =
coq-quickchick: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044511 to the same values=
 previously set
> notfixed 1044550 2.3.1-1
Bug #1044550 {Done: Daniel Baumann <daniel.baumann@progress-linux.org>} [sr=
c:dnscap] dnscap: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044550 to the same values=
 previously set
> notfixed 1044584 20.0.0-1
Bug #1044584 {Done: Thomas Goirand <zigo@debian.org>} [src:designate-dashbo=
ard] designate-dashboard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044584 to the same values=
 previously set
> notfixed 1044591 2025.03.27-1
Bug #1044591 {Done: Boyuan Yang <byang@debian.org>} [src:deepin-icon-theme]=
 deepin-icon-theme: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044591 to the same values=
 previously set
> notfixed 1044593 5.1.2-2
Bug #1044593 {Done: Peter Pentchev <roam@debian.org>} [src:confget] confget=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044593 to the same values=
 previously set
> notfixed 1044630 0.25.10-2
Bug #1044630 {Done: Bastian Germann <bage@debian.org>} [src:dsh] dsh: Fails=
 to build source after successful build
Ignoring request to alter fixed versions of bug #1044630 to the same values=
 previously set
> notfixed 1044632 1.9.0.93+dfsg2-3
Bug #1044632 {Done: Ileana Dumitrescu <ileanadumitrescu95@gmail.com>} [src:=
giac] giac: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044632 to the same values=
 previously set
> notfixed 1044633 0.25.0-2
Bug #1044633 {Done: Thomas Goirand <zigo@debian.org>} [src:designate-tempes=
t-plugin] designate-tempest-plugin: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1044633 to the same values=
 previously set
> notfixed 1044637 8.20.1+dfsg-1
Bug #1044637 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq] coq: Fails =
to build source after successful build
Ignoring request to alter fixed versions of bug #1044637 to the same values=
 previously set
> notfixed 1044642 4.12.4-1
Bug #1044642 {Done: Timo Aaltonen <tjaalton@debian.org>} [src:freeipa] free=
ipa: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044642 to the same values=
 previously set
> notfixed 1044649 0.9~rc3-11
Bug #1044649 {Done: Andreas Tille <tille@debian.org>} [src:ghmm] ghmm: Fail=
s to build source after successful build
Ignoring request to alter fixed versions of bug #1044649 to the same values=
 previously set
> notfixed 1044654 3.2.7+dfsg-1+deb13u2
Bug #1044654 {Done: Bernhard Schmidt <berni@debian.org>} [src:freeradius] f=
reeradius: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044654 to the same values=
 previously set
> notfixed 1044666 1:3.4.6+dfsg2-7
Bug #1044666 {Done: Nicolas Schodet <nico@ni.fr.eu.org>} [src:gcc-h8300-hms=
] gcc-h8300-hms: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044666 to the same values=
 previously set
> notfixed 1044720 5.3.3+repack-2
Bug #1044720 {Done: Georges Khaznadar <georgesk@debian.org>} [src:expeyes] =
expeyes: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044720 to the same values=
 previously set
> notfixed 1044740 5.7.12-1
Bug #1044740 {Done: Arun Kumar Pariyar <arun@debian.org>} [src:dtkgui] dtkg=
ui: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044740 to the same values=
 previously set
> notfixed 1044796 1.18.1-2
Bug #1044796 {Done: Ole Streicher <olebole@debian.org>} [src:healpy] healpy=
: Fails to build source after successful build
No longer marked as fixed in versions healpy/1.18.1-2.
> notfixed 1044825 3.2.3-1
Bug #1044825 {Done: Dennis Braun <snd@debian.org>} [src:elektroid] elektroi=
d: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044825 to the same values=
 previously set
> notfixed 1044832 3.11-4
Bug #1044832 {Done: Andreas Tille <tille@debian.org>} [src:fastml] fastml: =
Fails to build source after successful build
No longer marked as fixed in versions fastml/3.11-4.
> notfixed 1044858 1.10.0+ds-1
Bug #1044858 {Done: Jochen Sprickerhof <jspricke@debian.org>} [src:gpsbabel=
] gpsbabel: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044858 to the same values=
 previously set
> notfixed 1044886 0.2-3-4
Bug #1044886 {Done: Samuel Thibault <sthibault@debian.org>} [src:gtg-trace]=
 gtg-trace: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044886 to the same values=
 previously set
> notfixed 1044915 3.1.69+dfsg-3
Bug #1044915 {Done: Michael Tokarev <mjt@tls.msk.ru>} [src:emscripten] emsc=
ripten: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044915 to the same values=
 previously set
> notfixed 1044922 0~git20230107+ds-6
Bug #1044922 {Done: Andrej Shadura <andrewsh@debian.org>} [src:eos-sdk] eos=
-sdk: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044922 to the same values=
 previously set
> notfixed 1044936 2025.89-1~deb13u1
Bug #1044936 {Done: Guilhem Moulin <guilhem@debian.org>} [src:dropbear] dro=
pbear: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044936 to the same values=
 previously set
> notfixed 1044979 1:20.0.0-2
Bug #1044979 {Done: Thomas Goirand <zigo@debian.org>} [src:designate] desig=
nate: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044979 to the same values=
 previously set
> notfixed 1044981 2:30.0.0-3
Bug #1044981 {Done: Thomas Goirand <zigo@debian.org>} [src:glance] glance: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044981 to the same values=
 previously set
> notfixed 1044992 1.2.8-1
Bug #1044992 {Done: Patrick Matth=C3=A4i <pmatthaei@debian.org>} [src:fastn=
etmon] fastnetmon: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1044992 to the same values=
 previously set
> notfixed 1045001 5.13.8-1
Bug #1045001 {Done: Alastair McKinstry <mckinstry@debian.org>} [src:ecflow]=
 ecflow: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045001 to the same values=
 previously set
> notfixed 1045029 2.5.0-3
Bug #1045029 {Done: Thomas Goirand <zigo@debian.org>} [src:heat-tempest-plu=
gin] heat-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045029 to the same values=
 previously set
> notfixed 1045047 4.4.10-1
Bug #1045047 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:dssp=
] dssp: Fails to build source after successful build
No longer marked as fixed in versions dssp/4.4.10-1.
> notfixed 1045073 1.11.0-1
Bug #1045073 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-stdpp] coq-s=
tdpp: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045073 to the same values=
 previously set
> notfixed 1045076 4.11.1-1
Bug #1045076 {Done: Julien Puydt <jpuydt@debian.org>} [src:coq-interval] co=
q-interval: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045076 to the same values=
 previously set
> notfixed 1045085 1:2.10+dfsg-2
Bug #1045085 {Done: tony mancill <tmancill@debian.org>} [src:fop] fop: Fail=
s to build source after successful build
Ignoring request to alter fixed versions of bug #1045085 to the same values=
 previously set
> notfixed 1045093 1.1.1-2
Bug #1045093 {Done: PICCA Frederic-Emmanuel <frederic-emmanuel.picca@synchr=
otron-soleil.fr>} [src:h5z-zfp] h5z-zfp: Fails to build source after succes=
sful build
Ignoring request to alter fixed versions of bug #1045093 to the same values=
 previously set
> notfixed 1045112 0.7-5
Bug #1045112 {Done: Alastair McKinstry <mckinstry@debian.org>} [src:gramado=
ir] gramadoir: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045112 to the same values=
 previously set
> notfixed 1045122 24.11.4-0+deb13u1
Bug #1045122 {Done: Luca Boccassi <bluca@debian.org>} [src:dpdk] dpdk: Fail=
s to build source after successful build
Ignoring request to alter fixed versions of bug #1045122 to the same values=
 previously set
> notfixed 1045134 2.1.1-2
Bug #1045134 {Done: Martin <debacle@debian.org>} [src:gajim] gajim: Fails t=
o build source after successful build
Ignoring request to alter fixed versions of bug #1045134 to the same values=
 previously set
> notfixed 1045142 1.1.8-2
Bug #1045142 {Done: Scott Kitterman <scott@kitterman.com>} [src:dkimpy] dki=
mpy: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045142 to the same values=
 previously set
> notfixed 1045150 1.20.0+dfsg-2
Bug #1045150 {Done: Jonathan McDowell <noodles@earth.li>} [src:retroarch] r=
etroarch: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045150 to the same values=
 previously set
> notfixed 1045152 2.0.2-9
Bug #1045152 {Done: Thomas Goirand <zigo@debian.org>} [src:python-kafka] py=
thon-kafka: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045152 to the same values=
 previously set
> notfixed 1045153 0.13.0-7
Bug #1045153 {Done: Thomas Goirand <zigo@debian.org>} [src:python-marathon]=
 python-marathon: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045153 to the same values=
 previously set
> notfixed 1045155 1.3.0-1
Bug #1045155 {Done: Dominique Dumont <dod@debian.org>} [src:libtommath] lib=
tommath: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045155 to the same values=
 previously set
> notfixed 1045158 6.12.0.199+dfsg-6
Bug #1045158 {Done: Antoine Le Gonidec <vv221@debian.org>} [src:mono] mono:=
 Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045158 to the same values=
 previously set
> notfixed 1045170 1.8.2.2-5
Bug #1045170 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular] python-xstatic-angular: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045170 to the same values=
 previously set
> notfixed 1045186 1.5.70-4
Bug #1045186 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pyghmi] p=
ython-pyghmi: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045186 to the same values=
 previously set
> notfixed 1045198 1:4.8.0-2
Bug #1045198 {Done: Thomas Goirand <zigo@debian.org>} [src:python-glancecli=
ent] python-glanceclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045198 to the same values=
 previously set
> notfixed 1045213 2.2.2-1
Bug #1045213 {Done: Ludovic Rousseau <rousseau@debian.org>} [src:pyscard] p=
yscard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045213 to the same values=
 previously set
> notfixed 1045222 8.0.0-1
Bug #1045222 {Done: Thomas Goirand <zigo@debian.org>} [src:vitrage-dashboar=
d] vitrage-dashboard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045222 to the same values=
 previously set
> notfixed 1045267 4.22+dfsg-2
Bug #1045267 {Done: Yangfl <mmyangfl@gmail.com>} [src:libsimpleini] libsimp=
leini: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045267 to the same values=
 previously set
> notfixed 1045272 5.5.0-2
Bug #1045272 {Done: Thomas Goirand <zigo@debian.org>} [src:python-sushy] py=
thon-sushy: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045272 to the same values=
 previously set
> notfixed 1045282 1:1.1.2-4
Bug #1045282 {Done: Thomas Goirand <zigo@debian.org>} [src:python-rcssmin] =
python-rcssmin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045282 to the same values=
 previously set
> notfixed 1045286 2.16.3-1
Bug #1045286 {Done: Thomas Goirand <zigo@debian.org>} [src:python-proliantu=
tils] python-proliantutils: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045286 to the same values=
 previously set
> notfixed 1045300 4.1.1-2
Bug #1045300 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.serv=
ice] python-oslo.service: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045300 to the same values=
 previously set
> notfixed 1045311 4.9.6-11
Bug #1045311 {Done: Andreas Tille <tille@debian.org>} [src:mira] mira: Fail=
s to build source after successful build
No longer marked as fixed in versions mira/4.9.6-11.
> notfixed 1045316 7.32.4-7
Bug #1045316 {Done: Rebecca N. Palmer <rebecca_palmer@zoho.com>} [src:snake=
make] snakemake: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045316 to the same values=
 previously set
> notfixed 1045355 3.1.6-1
Bug #1045355 {Done: Bdale Garbee <bdale@gag.com>} [src:pcb-rnd] pcb-rnd: Fa=
ils to build source after successful build
Ignoring request to alter fixed versions of bug #1045355 to the same values=
 previously set
> notfixed 1045357 4.6.0-3
Bug #1045357 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.vmwa=
re] python-oslo.vmware: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045357 to the same values=
 previously set
> notfixed 1045364 1.5.3-2
Bug #1045364 {Done: Andreas Tille <tille@debian.org>} [src:oscar] oscar: Fa=
ils to build source after successful build
No longer marked as fixed in versions oscar/1.5.3-2.
> notfixed 1045366 1:2.9.4-2
Bug #1045366 {Done: Petter Reinholdtsen <pere@debian.org>} [src:linuxcnc] l=
inuxcnc: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045366 to the same values=
 previously set
> notfixed 1045381 0.24.1-1
Bug #1045381 {Done: Carsten Schoenert <c.schoenert@t-online.de>} [src:pytho=
n-validate-pyproject] python-validate-pyproject: Fails to build source afte=
r successful build
Ignoring request to alter fixed versions of bug #1045381 to the same values=
 previously set
> notfixed 1045383 6.1.1-2
Bug #1045383 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pbr] pyth=
on-pbr: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045383 to the same values=
 previously set
> notfixed 1045393 2.5.0-1
Bug #1045393 {Done: Jeremy Stanley <fungi@yuggoth.org>} [src:weather-util] =
weather-util: Fails to build source after successful build
No longer marked as fixed in versions weather-util/2.5.0-1.
> notfixed 1045395 1.5-4
Bug #1045395 {Done: Thomas Goirand <zigo@debian.org>} [src:python-infinity]=
 python-infinity: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045395 to the same values=
 previously set
> notfixed 1045407 2.0.1-2
Bug #1045407 {Done: Joachim Wiedorn <joodebian@joonet.de>} [src:xfe] xfe: F=
ails to build source after successful build
Ignoring request to alter fixed versions of bug #1045407 to the same values=
 previously set
> notfixed 1045412 2.0.1-12
Bug #1045412 {Done: Vincent Cheng <vcheng@debian.org>} [src:mypaint] mypain=
t: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045412 to the same values=
 previously set
> notfixed 1045430 6.3.8-1
Bug #1045430 {Done: Nathan Scott <nathans@debian.org>} [src:pcp] pcp: Fails=
 to build source after successful build
Ignoring request to alter fixed versions of bug #1045430 to the same values=
 previously set
> notfixed 1045440 0.0~git20241122.9d9b633-1
Bug #1045440 {Done: Boyuan Yang <byang@debian.org>} [src:rime-cantonese] ri=
me-cantonese: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045440 to the same values=
 previously set
> notfixed 1045450 6.6.0-2
Bug #1045450 {Done: Thomas Goirand <zigo@debian.org>} [src:vitrage-tempest-=
plugin] vitrage-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045450 to the same values=
 previously set
> notfixed 1045481 2.8.4.2-4
Bug #1045481 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-m=
oment] python-xstatic-moment: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045481 to the same values=
 previously set
> notfixed 1045487 0.15.2-1
Bug #1045487 {Done: Sergio de Almeida Cipriano Junior <sergiosacj@riseup.ne=
t>} [src:typer] typer: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045487 to the same values=
 previously set
> notfixed 1045493 3.6.1-2
Bug #1045493 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ceilomete=
rmiddleware] python-ceilometermiddleware: Fails to build source after succe=
ssful build
Ignoring request to alter fixed versions of bug #1045493 to the same values=
 previously set
> notfixed 1045510 1.14.0.2-6
Bug #1045510 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-q=
unit] python-xstatic-qunit: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045510 to the same values=
 previously set
> notfixed 1045515 1.7.0-1
Bug #1045515 {Done: Jussi Pakkanen <jpakkane@gmail.com>} [src:meson] meson:=
 Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045515 to the same values=
 previously set
> notfixed 1045526 1:9.7.1-3
Bug #1045526 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.conf=
ig] python-oslo.config: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045526 to the same values=
 previously set
> notfixed 1045535 1.1.11-10
Bug #1045535 {Done: Andreas Tille <tille@debian.org>} [src:jellyfish1] jell=
yfish1: Fails to build source after successful build
No longer marked as fixed in versions jellyfish1/1.1.11-10.
> notfixed 1045566 18.0.0-1
Bug #1045566 {Done: Thomas Goirand <zigo@debian.org>} [src:zaqar-ui] zaqar-=
ui: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045566 to the same values=
 previously set
> notfixed 1045567 5.4.6+really5.3.2-1
Bug #1045567 {Done: Bastian Germann <bage@debian.org>} [src:reprepro] repre=
pro: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045567 to the same values=
 previously set
> notfixed 1045587 20240308-1
Bug #1045587 {Done: Hilko Bengen <bengen@debian.org>} [src:libqcow] libqcow=
: Fails to build source after successful build
No longer marked as fixed in versions libqcow/20240308-1.
> notfixed 1045609 1:11.4.0-2
Bug #1045609 {Done: Thomas Goirand <zigo@debian.org>} [src:python-neutroncl=
ient] python-neutronclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045609 to the same values=
 previously set
> notfixed 1045611 1.7-1
Bug #1045611 {Done: St=C3=A9phane Glondu <glondu@debian.org>} [src:ocaml-be=
nchmark] ocaml-benchmark: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045611 to the same values=
 previously set
> notfixed 1045615 0.11-2
Bug #1045615 {Done: Georges Khaznadar <georgesk@debian.org>} [src:turing] t=
uring: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045615 to the same values=
 previously set
> notfixed 1045618 1.7.0-5
Bug #1045618 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-servic=
e-types] python-os-service-types: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1045618 to the same values=
 previously set
> notfixed 1045619 1.13.1-1
Bug #1045619 {Done: Thomas Goirand <zigo@debian.org>} [src:python-wsgi-inte=
rcept] python-wsgi-intercept: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045619 to the same values=
 previously set
> notfixed 1045639 0.11.2-1+deb13u1
Bug #1045639 {Done: Martin Pitt <mpitt@debian.org>} [src:libssh] libssh: Fa=
ils to build source after successful build
Ignoring request to alter fixed versions of bug #1045639 to the same values=
 previously set
> notfixed 1045642 0.6.4.0-5
Bug #1045642 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-d=
agre] python-xstatic-dagre: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045642 to the same values=
 previously set
> notfixed 1045651 0.1.3-5
Bug #1045651 {Done: Thomas Goirand <zigo@debian.org>} [src:python-morph] py=
thon-morph: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045651 to the same values=
 previously set
> notfixed 1045653 13.0.0-1
Bug #1045653 {Done: Thomas Goirand <zigo@debian.org>} [src:watcher-dashboar=
d] watcher-dashboard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045653 to the same values=
 previously set
> notfixed 1045662 3.6.0-3
Bug #1045662 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.priv=
sep] python-oslo.privsep: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045662 to the same values=
 previously set
> notfixed 1045672 4.5.2-1
Bug #1045672 {Done: Hilko Bengen <bengen@debian.org>} [src:yara] yara: Fail=
s to build source after successful build
Ignoring request to alter fixed versions of bug #1045672 to the same values=
 previously set
> notfixed 1045678 0.26-2
Bug #1045678 {Done: A. Maitland Bottoms <bottoms@debian.org>} [src:libiio] =
libiio: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045678 to the same values=
 previously set
> notfixed 1045694 1.10-2
Bug #1045694 {Done: Andrew Ruthven <andrew@etc.gen.nz>} [src:rt-extension-m=
ergeusers] rt-extension-mergeusers: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1045694 to the same values=
 previously set
> notfixed 1045706 1.18.1+dfsg-1
Bug #1045706 {Done: Andreas Tille <tille@debian.org>} [src:r-bioc-rhdf5filt=
ers] r-bioc-rhdf5filters: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045706 to the same values=
 previously set
> notfixed 1045710 0.0.4.0-4
Bug #1045710 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-uuid] python-xstatic-angular-uuid: Fails to build source after succe=
ssful build
Ignoring request to alter fixed versions of bug #1045710 to the same values=
 previously set
> notfixed 1045732 0.2.3-4
Bug #1045732 {Done: Thomas Goirand <zigo@debian.org>} [src:python-cursive] =
python-cursive: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045732 to the same values=
 previously set
> notfixed 1045748 1.6.50.2-6
Bug #1045748 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-m=
di] python-xstatic-mdi: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045748 to the same values=
 previously set
> notfixed 1045749 0.11.0-3
Bug #1045749 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.metr=
ics] python-oslo.metrics: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045749 to the same values=
 previously set
> notfixed 1045759 2.1.0-4
Bug #1045759 {Done: Thomas Goirand <zigo@debian.org>} [src:python-bashate] =
python-bashate: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045759 to the same values=
 previously set
> notfixed 1045761 2.5.0-2
Bug #1045761 {Done: Thomas Goirand <zigo@debian.org>} [src:trove-tempest-pl=
ugin] trove-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045761 to the same values=
 previously set
> notfixed 1045771 2.14.5.1-8
Bug #1045771 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query.tablesorter] python-xstatic-jquery.tablesorter: Fails to build source=
 after successful build
Ignoring request to alter fixed versions of bug #1045771 to the same values=
 previously set
> notfixed 1045774 20.0.0-1
Bug #1045774 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-sfc] =
networking-sfc: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045774 to the same values=
 previously set
> notfixed 1045775 2.3.0-4
Bug #1045775 {Done: Manuel Guerra <ar.manuelguerra@gmail.com>} [src:raphael=
] raphael: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045775 to the same values=
 previously set
> notfixed 1045791 19.0.0-1
Bug #1045791 {Done: Thomas Goirand <zigo@debian.org>} [src:masakari-monitor=
s] masakari-monitors: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045791 to the same values=
 previously set
> notfixed 1045808 1:5.1+git20250320+dfsg-1
Bug #1045808 {Done: Florian Schlichting <fsfs@debian.org>} [src:xxdiff] xxd=
iff: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045808 to the same values=
 previously set
> notfixed 1045814 3.3.2.1+dfsg1-4
Bug #1045814 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query-migrate] python-xstatic-jquery-migrate: Fails to build source after s=
uccessful build
Ignoring request to alter fixed versions of bug #1045814 to the same values=
 previously set
> notfixed 1045818 0.5.0.0-6
Bug #1045818 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-r=
oboto-fontface] python-xstatic-roboto-fontface: Fails to build source after=
 successful build
Ignoring request to alter fixed versions of bug #1045818 to the same values=
 previously set
> notfixed 1045822 0.5.0~hg494-1
Bug #1045822 {Done: Martin <debacle@debian.org>} [src:libervia-pubsub] libe=
rvia-pubsub: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045822 to the same values=
 previously set
> notfixed 1045869 25.03.0-1
Bug #1045869 {Done: Thomas Goirand <zigo@debian.org>} [src:ovn] ovn: Fails =
to build source after successful build
Ignoring request to alter fixed versions of bug #1045869 to the same values=
 previously set
> notfixed 1045877 2025.2.18+dfsg1-5
Bug #1045877 {Done: Drew Parsons <dparsons@debian.org>} [src:pymatgen] pyma=
tgen: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045877 to the same values=
 previously set
> notfixed 1045897 1.0.1-9
Bug #1045897 {Done: Andreas Tille <tille@debian.org>} [src:reprof] reprof: =
Fails to build source after successful build
No longer marked as fixed in versions reprof/1.0.1-9.
> notfixed 1045916 5.6-1
Bug #1045916 {Done: Georges Khaznadar <georgesk@debian.org>} [src:scolasync=
] scolasync: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045916 to the same values=
 previously set
> notfixed 1045926 2.8.5-2
Bug #1045926 {Done: Ole Streicher <olebole@debian.org>} [src:iraf-rvsao] ir=
af-rvsao: Fails to build source after successful build
No longer marked as fixed in versions iraf-rvsao/2.8.5-2.
> notfixed 1045932 0.2.2-1
Bug #1045932 {Done: Lance Lin <lq27267@gmail.com>} [src:python-tinyalign] p=
ython-tinyalign: Fails to build source after successful build
No longer marked as fixed in versions python-tinyalign/0.2.2-1.
> notfixed 1045942 1.19.0-3
Bug #1045942 {Done: Matthias Geiger <werdahias@riseup.net>} [src:rust-gping=
] rust-gping: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045942 to the same values=
 previously set
> notfixed 1045949 0.74.0-1
Bug #1045949 {Done: Luca Boccassi <bluca@debian.org>} [src:libdnf] libdnf: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045949 to the same values=
 previously set
> notfixed 1045954 5.3.0-4
Bug #1045954 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ironic-in=
spector-client] python-ironic-inspector-client: Fails to build source after=
 successful build
Ignoring request to alter fixed versions of bug #1045954 to the same values=
 previously set
> notfixed 1045967 2.5.0-2
Bug #1045967 {Done: Thomas Goirand <zigo@debian.org>} [src:telemetry-tempes=
t-plugin] telemetry-tempest-plugin: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1045967 to the same values=
 previously set
> notfixed 1045968 1.0.6-3
Bug #1045968 {Done: Thomas Goirand <zigo@debian.org>} [src:python-django-ap=
pconf] python-django-appconf: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045968 to the same values=
 previously set
> notfixed 1045981 4.16.4.1-5
Bug #1045981 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-l=
odash] python-xstatic-lodash: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045981 to the same values=
 previously set
> notfixed 1045986 2.0.15-1
Bug #1045986 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:tort=
oize] tortoize: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045986 to the same values=
 previously set
> notfixed 1045988 6.13.0-2
Bug #1045988 {Done: Bastian Germann <bage@debian.org>} [src:xfsprogs] xfspr=
ogs: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1045988 to the same values=
 previously set
> notfixed 1046018 2:12.5.0-2+deb13u1
Bug #1046018 {Done: Bernd Zeimetz <bzed@debian.org>} [src:open-vm-tools] op=
en-vm-tools: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046018 to the same values=
 previously set
> notfixed 1046021 3.0.0-2
Bug #1046021 {Done: Thomas Goirand <zigo@debian.org>} [src:zaqar-tempest-pl=
ugin] zaqar-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046021 to the same values=
 previously set
> notfixed 1046082 6.3.1-3
Bug #1046082 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.midd=
leware] python-oslo.middleware: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046082 to the same values=
 previously set
> notfixed 1046090 4.2.0-6
Bug #1046090 {Done: Thomas Goirand <zigo@debian.org>} [src:python-osprofile=
r] python-osprofiler: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046090 to the same values=
 previously set
> notfixed 1046108 3.0.0-5
Bug #1046108 {Done: Thomas Goirand <zigo@debian.org>} [src:python-debtcolle=
ctor] python-debtcollector: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046108 to the same values=
 previously set
> notfixed 1046125 1:43.0.0-3
Bug #1046125 {Done: Thomas Goirand <zigo@debian.org>} [src:tempest] tempest=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046125 to the same values=
 previously set
> notfixed 1046156 13.1.0-3
Bug #1046156 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-refres=
h-config] python-os-refresh-config: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1046156 to the same values=
 previously set
> notfixed 1046169 6.5.0-2
Bug #1046169 {Done: Thomas Goirand <zigo@debian.org>} [src:ironic-ui] ironi=
c-ui: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046169 to the same values=
 previously set
> notfixed 1046172 1.2.5-6
Bug #1046172 {Done: Thomas Goirand <zigo@debian.org>} [src:python-calmjs.pa=
rse] python-calmjs.parse: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046172 to the same values=
 previously set
> notfixed 1046175 1:2.2.4+ds-1
Bug #1046175 {Done: Stefano Rivera <stefanor@debian.org>} [src:numpy] numpy=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046175 to the same values=
 previously set
> notfixed 1046176 1.8.2-3
Bug #1046176 {Done: J=C3=A9r=C3=B4me Charaoui <jerome@riseup.net>} [src:rin=
g-clojure] ring-clojure: Fails to build source after successful build
No longer marked as fixed in versions ring-clojure/1.8.2-3.
> notfixed 1046201 6.5.1-3
Bug #1046201 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.i18n=
] python-oslo.i18n: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046201 to the same values=
 previously set
> notfixed 1046221 3.4.1.0-4
Bug #1046221 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-b=
ootstrap-scss] python-xstatic-bootstrap-scss: Fails to build source after s=
uccessful build
Ignoring request to alter fixed versions of bug #1046221 to the same values=
 previously set
> notfixed 1046222 12.4.0-2
Bug #1046222 {Done: Thomas Goirand <zigo@debian.org>} [src:ironic-inspector=
] ironic-inspector: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046222 to the same values=
 previously set
> notfixed 1046233 0.3.19-1
Bug #1046233 {Done: Phil Wyett <philip.wyett@kathenas.org>} [src:mpgrafic] =
mpgrafic: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046233 to the same values=
 previously set
> notfixed 1046238 0.1.20150729-7
Bug #1046238 {Done: Andreas Tille <tille@debian.org>} [src:qrisk2] qrisk2: =
Fails to build source after successful build
No longer marked as fixed in versions qrisk2/0.1.20150729-7.
> notfixed 1046271 0.16.3-1
Bug #1046271 {Done: Dennis Braun <snd@debian.org>} [src:pyliblo] pyliblo: F=
ails to build source after successful build
Ignoring request to alter fixed versions of bug #1046271 to the same values=
 previously set
> notfixed 1046273 16.0.0-1
Bug #1046273 {Done: Thomas Goirand <zigo@debian.org>} [src:magnum-ui] magnu=
m-ui: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046273 to the same values=
 previously set
> notfixed 1046279 7.1.0-3
Bug #1046279 {Done: Thomas Goirand <zigo@debian.org>} [src:python-barbicanc=
lient] python-barbicanclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046279 to the same values=
 previously set
> notfixed 1046280 1.0.3-6
Bug #1046280 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic] =
python-xstatic: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046280 to the same values=
 previously set
> notfixed 1046283 2.11.0-2
Bug #1046283 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ovsdbapp]=
 python-ovsdbapp: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046283 to the same values=
 previously set
> notfixed 1046287 0.17-6
Bug #1046287 {Done: Thomas Goirand <zigo@debian.org>} [src:sphinxcontrib-pr=
ogramoutput] sphinxcontrib-programoutput: Fails to build source after succe=
ssful build
Ignoring request to alter fixed versions of bug #1046287 to the same values=
 previously set
> notfixed 1046290 0.0.7.0-7
Bug #1046290 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-t=
erm.js] python-xstatic-term.js: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046290 to the same values=
 previously set
> notfixed 1046291 17.2.1-2
Bug #1046291 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.db] =
python-oslo.db: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046291 to the same values=
 previously set
> notfixed 1046302 4.5.1-3
Bug #1046302 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.poli=
cy] python-oslo.policy: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046302 to the same values=
 previously set
> notfixed 1046311 1.5.4-2
Bug #1046311 {Done: Roland Mas <lolando@debian.org>} [src:python-mrcfile] p=
ython-mrcfile: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046311 to the same values=
 previously set
> notfixed 1046323 1.05.00-1
Bug #1046323 {Done: Frank B. Brokken <f.b.brokken@rug.nl>} [src:ssh-cron] s=
sh-cron: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046323 to the same values=
 previously set
> notfixed 1046350 10.9.0-2
Bug #1046350 {Done: Thomas Goirand <zigo@debian.org>} [src:python-keystonem=
iddleware] python-keystonemiddleware: Fails to build source after successfu=
l build
Ignoring request to alter fixed versions of bug #1046350 to the same values=
 previously set
> notfixed 1046363 1.4.36-1
Bug #1046363 {Done: Gunnar Hjalmarsson <gunnarhj@debian.org>} [src:ibus-m17=
n] ibus-m17n: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046363 to the same values=
 previously set
> notfixed 1046372 1.005-13
Bug #1046372 {Done: Andreas Tille <tille@debian.org>} [src:librcsb-core-wra=
pper] librcsb-core-wrapper: Fails to build source after successful build
No longer marked as fixed in versions librcsb-core-wrapper/1.005-13.
> notfixed 1046388 3.2.1-1
Bug #1046388 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:libp=
db-redo] libpdb-redo: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046388 to the same values=
 previously set
> notfixed 1046396 1.12.1-3
Bug #1046396 {Done: Thomas Goirand <zigo@debian.org>} [src:python-requests-=
mock] python-requests-mock: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046396 to the same values=
 previously set
> notfixed 1046402 1.1.0-5
Bug #1046402 {Done: Thomas Goirand <zigo@debian.org>} [src:tempest-horizon]=
 tempest-horizon: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046402 to the same values=
 previously set
> notfixed 1046403 1.12.0.1+debian+dfsg3-7
Bug #1046403 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query-ui] python-xstatic-jquery-ui: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1046403 to the same values=
 previously set
> notfixed 1046430 0.1.1.0-4
Bug #1046430 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
son2yaml] python-xstatic-json2yaml: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1046430 to the same values=
 previously set
> notfixed 1046444 2.1.3+final-1
Bug #1046444 {Done: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de=
>} [src:virtualjaguar] virtualjaguar: Fails to build source after successfu=
l build
No longer marked as fixed in versions virtualjaguar/2.1.3+final-1.
> notfixed 1046451 1.3.2-1
Bug #1046451 {Done: Thomas Goirand <zigo@debian.org>} [src:python-typepy] p=
ython-typepy: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046451 to the same values=
 previously set
> notfixed 1046459 4.4.0-5
Bug #1046459 {Done: Thomas Goirand <zigo@debian.org>} [src:python-openstack=
sdk] python-openstacksdk: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046459 to the same values=
 previously set
> notfixed 1046467 3.0.0-2
Bug #1046467 {Done: Thomas Goirand <zigo@debian.org>} [src:octavia-tempest-=
plugin] octavia-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046467 to the same values=
 previously set
> notfixed 1046493 1.15.3-1
Bug #1046493 {Done: Drew Parsons <dparsons@debian.org>} [src:scipy] scipy: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046493 to the same values=
 previously set
> notfixed 1046499 0.3.0-6
Bug #1046499 {Done: Thomas Goirand <zigo@debian.org>} [src:python-sphinxcon=
trib.apidoc] python-sphinxcontrib.apidoc: Fails to build source after succe=
ssful build
Ignoring request to alter fixed versions of bug #1046499 to the same values=
 previously set
> notfixed 1046505 1:29.0.0-7
Bug #1046505 {Done: Thomas Goirand <zigo@debian.org>} [src:ironic] ironic: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046505 to the same values=
 previously set
> notfixed 1046528 1.1.15+ds1-2
Bug #1046528 {Done: Reinhard Tartler <siretart@tauware.de>} [src:runc] runc=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046528 to the same values=
 previously set
> notfixed 1046531 1.0.8-3
Bug #1046531 {Done: Bdale Garbee <bdale@gag.com>} [src:sch-rnd] sch-rnd: Fa=
ils to build source after successful build
Ignoring request to alter fixed versions of bug #1046531 to the same values=
 previously set
> notfixed 1046536 2.0.3-5
Bug #1046536 {Done: Thomas Goirand <zigo@debian.org>} [src:python-django-py=
scss] python-django-pyscss: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046536 to the same values=
 previously set
> notfixed 1046543 5.0~git20180903.a14bd0b-6
Bug #1046543 {Done: Mike Gabriel <sunweaver@debian.org>} [src:qtfeedback-op=
ensource-src] qtfeedback-opensource-src: Fails to build source after succes=
sful build
No longer marked as fixed in versions qtfeedback-opensource-src/5.0~git2018=
0903.a14bd0b-6.
> notfixed 1046551 8.2.0-4
Bug #1046551 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.util=
s] python-oslo.utils: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046551 to the same values=
 previously set
> notfixed 1046552 2.0.4.1-6
Bug #1046552 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query.quicksearch] python-xstatic-jquery.quicksearch: Fails to build source=
 after successful build
Ignoring request to alter fixed versions of bug #1046552 to the same values=
 previously set
> notfixed 1046557 1.4.13.2-7
Bug #1046557 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-s=
mart-table] python-xstatic-smart-table: Fails to build source after success=
ful build
Ignoring request to alter fixed versions of bug #1046557 to the same values=
 previously set
> notfixed 1046561 3.18.2-3
Bug #1046561 {Done: Thomas Goirand <zigo@debian.org>} [src:python-neutron-l=
ib] python-neutron-lib: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046561 to the same values=
 previously set
> notfixed 1046565 2.0.0-3
Bug #1046565 {Done: Thomas Goirand <zigo@debian.org>} [src:python-rfc3986] =
python-rfc3986: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046565 to the same values=
 previously set
> notfixed 1046569 43.0.0-3
Bug #1046569 {Done: J=C3=A9r=C3=A9my Lal <kapouer@melix.org>} [src:python-c=
ryptography] python-cryptography: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1046569 to the same values=
 previously set
> notfixed 1046571 2.7.0-2
Bug #1046571 {Done: Thomas Goirand <zigo@debian.org>} [src:manila-tempest-p=
lugin] manila-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046571 to the same values=
 previously set
> notfixed 1046600 0.6.3-5
Bug #1046600 {Done: Thomas Goirand <zigo@debian.org>} [src:python-wsaccel] =
python-wsaccel: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046600 to the same values=
 previously set
> notfixed 1046604 1.2.7.0-7
Bug #1046604 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-t=
v4] python-xstatic-tv4: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046604 to the same values=
 previously set
> notfixed 1046618 3.6.0-3
Bug #1046618 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.vers=
ionedobjects] python-oslo.versionedobjects: Fails to build source after suc=
cessful build
Ignoring request to alter fixed versions of bug #1046618 to the same values=
 previously set
> notfixed 1046628 23.1.2+dfsg1-2
Bug #1046628 {Done: Thomas Goirand <zigo@debian.org>} [src:python-autobahn]=
 python-autobahn: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046628 to the same values=
 previously set
> notfixed 1046642 4.16.0.0-4
Bug #1046642 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-vis] python-xstatic-angular-vis: Fails to build source after success=
ful build
Ignoring request to alter fixed versions of bug #1046642 to the same values=
 previously set
> notfixed 1046699 3.2.16+dfsg-3
Bug #1046699 {Done: Jochen Sprickerhof <jspricke@debian.org>} [src:olm] olm=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046699 to the same values=
 previously set
> notfixed 1046710 0.3.5-5
Bug #1046710 {Done: Thomas Goirand <zigo@debian.org>} [src:python-logutils]=
 python-logutils: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046710 to the same values=
 previously set
> notfixed 1046712 0.4.4-6
Bug #1046712 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pyhcl] py=
thon-pyhcl: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046712 to the same values=
 previously set
> notfixed 1046716 0.9.81+ds1-2
Bug #1046716 {Done: Roland Mas <lolando@debian.org>} [src:xraylarch] xrayla=
rch: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046716 to the same values=
 previously set
> notfixed 1046775 1.4.2+dfsg-8
Bug #1046775 {Done: Andreas Tille <tille@debian.org>} [src:scikit-learn] sc=
ikit-learn: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046775 to the same values=
 previously set
> notfixed 1046778 0.5.22.0-5
Bug #1046778 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-m=
oment-timezone] python-xstatic-moment-timezone: Fails to build source after=
 successful build
Ignoring request to alter fixed versions of bug #1046778 to the same values=
 previously set
> notfixed 1046783 1.3.1-3
Bug #1046783 {Done: J=C3=B6rg Frings-F=C3=BCrst <debian@jff.email>} [src:sa=
ne-backends] sane-backends: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046783 to the same values=
 previously set
> notfixed 1046789 1.62-3
Bug #1046789 {Done: Thomas Goirand <zigo@debian.org>} [src:python-memcache]=
 python-memcache: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046789 to the same values=
 previously set
> notfixed 1046791 2.0.0-4
Bug #1046791 {Done: Thomas Goirand <zigo@debian.org>} [src:python-yaql] pyt=
hon-yaql: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046791 to the same values=
 previously set
> notfixed 1046813 4.0.5-6+deb13u2
Bug #1046813 {Done: Thomas Goirand <zigo@debian.org>} [src:rabbitmq-server]=
 rabbitmq-server: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046813 to the same values=
 previously set
> notfixed 1046816 7.5.1-3
Bug #1046816 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.root=
wrap] python-oslo.rootwrap: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046816 to the same values=
 previously set
> notfixed 1046832 2.4-3
Bug #1046832 {Done: Thomas Goirand <zigo@debian.org>} [src:python-json-poin=
ter] python-json-pointer: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046832 to the same values=
 previously set
> notfixed 1046843 2.4.1.1-7
Bug #1046843 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
asmine] python-xstatic-jasmine: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046843 to the same values=
 previously set
> notfixed 1046849 1.14.5-3
Bug #1046849 {Done: James McCoy <jamessan@debian.org>} [src:subversion] sub=
version: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046849 to the same values=
 previously set
> notfixed 1046864 2.32.0-4
Bug #1046864 {Done: Drew Parsons <dparsons@debian.org>} [src:hypre] hypre: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046864 to the same values=
 previously set
> notfixed 1046913 2.3.1.1-7
Bug #1046913 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
sencrypt] python-xstatic-jsencrypt: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1046913 to the same values=
 previously set
> notfixed 1046915 3.4.0-1
Bug #1046915 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-traits=
] python-os-traits: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046915 to the same values=
 previously set
> notfixed 1046921 1.08-2
Bug #1046921 {Done: Andrew Ruthven <andrew@etc.gen.nz>} [src:rt-extension-j=
sgantt] rt-extension-jsgantt: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046921 to the same values=
 previously set
> notfixed 1046931 4.8.1-2
Bug #1046931 {Done: Thomas Goirand <zigo@debian.org>} [src:python-magnumcli=
ent] python-magnumclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046931 to the same values=
 previously set
> notfixed 1046957 2.4.1.0-6
Bug #1046957 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-gettext] python-xstatic-angular-gettext: Fails to build source after=
 successful build
Ignoring request to alter fixed versions of bug #1046957 to the same values=
 previously set
> notfixed 1046966 7.10.0-2
Bug #1046966 {Done: Teus Benschop <teusbenschop@debian.org>} [src:libpqxx] =
libpqxx: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046966 to the same values=
 previously set
> notfixed 1046977 0.12.1-6
Bug #1046977 {Done: Thomas Goirand <zigo@debian.org>} [src:python-wsme] pyt=
hon-wsme: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046977 to the same values=
 previously set
> notfixed 1046994 2.8.1+dfsg-2
Bug #1046994 {Done: Simon McVittie <smcv@debian.org>} [src:libsdl2-mixer] l=
ibsdl2-mixer: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046994 to the same values=
 previously set
> notfixed 1046999 3.4.0-2
Bug #1046999 {Done: Thomas Goirand <zigo@debian.org>} [src:watcher-tempest-=
plugin] watcher-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1046999 to the same values=
 previously set
> notfixed 1047018 4.0.1-1
Bug #1047018 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pycadf] p=
ython-pycadf: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047018 to the same values=
 previously set
> notfixed 1047020 5.1.5-11
Bug #1047020 {Done: James McCoy <jamessan@debian.org>} [src:lua5.1] lua5.1:=
 Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047020 to the same values=
 previously set
> notfixed 1047030 4.1.0-2
Bug #1047030 {Done: Thomas Goirand <zigo@debian.org>} [src:python-reno] pyt=
hon-reno: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047030 to the same values=
 previously set
> notfixed 1047043 5.4.3-5
Bug #1047043 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:insigh=
ttoolkit5] insighttoolkit5: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047043 to the same values=
 previously set
> notfixed 1047070 2.7.0-2
Bug #1047070 {Done: Thomas Goirand <zigo@debian.org>} [src:magnum-tempest-p=
lugin] magnum-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047070 to the same values=
 previously set
> notfixed 1047089 2.5.0-3
Bug #1047089 {Done: Thomas Goirand <zigo@debian.org>} [src:python-daemonize=
] python-daemonize: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047089 to the same values=
 previously set
> notfixed 1047091 3.0.0-5
Bug #1047091 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ldappool]=
 python-ldappool: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047091 to the same values=
 previously set
> notfixed 1047097 6.2.0-2
Bug #1047097 {Done: Thomas Goirand <zigo@debian.org>} [src:python-designate=
client] python-designateclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047097 to the same values=
 previously set
> notfixed 1047105 1.5.0.2-7
Bug #1047105 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-r=
ickshaw] python-xstatic-rickshaw: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1047105 to the same values=
 previously set
> notfixed 1047135 1.1.0-4
Bug #1047135 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-resour=
ce-classes] python-os-resource-classes: Fails to build source after success=
ful build
Ignoring request to alter fixed versions of bug #1047135 to the same values=
 previously set
> notfixed 1047146 0.16.7-1
Bug #1047146 {Done: Christoph Schmidt-Hieber <christsc@gmx.de>} [src:stimfi=
t] stimfit: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047146 to the same values=
 previously set
> notfixed 1047161 1.3.3-1
Bug #1047161 {Done: Thomas Goirand <zigo@debian.org>} [src:python-dogpile.c=
ache] python-dogpile.cache: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047161 to the same values=
 previously set
> notfixed 1047182 2.6.0-1
Bug #1047182 {Done: Thomas Goirand <zigo@debian.org>} [src:mistral-tempest-=
plugin] mistral-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047182 to the same values=
 previously set
> notfixed 1047192 3.8.0-2
Bug #1047192 {Done: Thomas Goirand <zigo@debian.org>} [src:python-octavia-l=
ib] python-octavia-lib: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047192 to the same values=
 previously set
> notfixed 1047194 4.8.7+ds-1
Bug #1047194 {Done: Tom Jampen <tom@cryptography.ch>} [src:texstudio] texst=
udio: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047194 to the same values=
 previously set
> notfixed 1047199 3.22.4-1
Bug #1047199 {Done: Drew Parsons <dparsons@debian.org>} [src:petsc4py] pets=
c4py: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047199 to the same values=
 previously set
> notfixed 1047202 0.4.2+repack1-5
Bug #1047202 {Done: Agustin Martin Domingo <agmartin@debian.org>} [src:ispe=
ll-fo] ispell-fo: Fails to build source after successful build
No longer marked as fixed in versions ispell-fo/0.4.2+repack1-5.
> notfixed 1047205 6.5.0-2
Bug #1047205 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-barem=
etal] networking-baremetal: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047205 to the same values=
 previously set
> notfixed 1047213 4.6.1731418769.97d9a7fd-4
Bug #1047213 {Done: Philip Hands <phil@hands.com>} [src:os-autoinst] os-aut=
oinst: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047213 to the same values=
 previously set
> notfixed 1047244 0.14.1-3
Bug #1047244 {Done: Ole Streicher <olebole@debian.org>} [src:reproject] rep=
roject: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047244 to the same values=
 previously set
> notfixed 1047249 3.0.0-4
Bug #1047249 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-testr]=
 python-os-testr: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047249 to the same values=
 previously set
> notfixed 1047254 0.11.0-1
Bug #1047254 {Done: Thomas Goirand <zigo@debian.org>} [src:sphinxcontrib-pe=
canwsme] sphinxcontrib-pecanwsme: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1047254 to the same values=
 previously set
> notfixed 1047264 3.0.11+~0.4.1-3
Bug #1047264 {Done: Jonas Smedegaard <dr@jones.dk>} [src:rust-ureq] rust-ur=
eq: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047264 to the same values=
 previously set
> notfixed 1047280 0.14.4+dfsg-1
Bug #1047280 {Done: Rebecca N. Palmer <rebecca_palmer@zoho.com>} [src:stats=
models] statsmodels: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047280 to the same values=
 previously set
> notfixed 1047288 3.10.1-3
Bug #1047288 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.cach=
e] python-oslo.cache: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047288 to the same values=
 previously set
> notfixed 1047327 1.17.11-1
Bug #1047327 {Done: Gunnar Hjalmarsson <gunnarhj@debian.org>} [src:ibus-tab=
le] ibus-table: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047327 to the same values=
 previously set
> notfixed 1047333 1.4.4+dfsg-1
Bug #1047333 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:ivar] =
ivar: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047333 to the same values=
 previously set
> notfixed 1047356 1.0.0.337-1
Bug #1047356 {Done: Thorsten Alteholz <debian@alteholz.de>} [src:udm] udm: =
Fails to build source after successful build
No longer marked as fixed in versions udm/1.0.0.337-1.
> notfixed 1047384 20.0.0-2
Bug #1047384 {Done: Thomas Goirand <zigo@debian.org>} [src:zaqar] zaqar: Fa=
ils to build source after successful build
Ignoring request to alter fixed versions of bug #1047384 to the same values=
 previously set
> notfixed 1047394 3.0.0-3
Bug #1047394 {Done: Thomas Goirand <zigo@debian.org>} [src:python-zaqarclie=
nt] python-zaqarclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047394 to the same values=
 previously set
> notfixed 1047401 9.0-1
Bug #1047401 {Done: Roland Gruber <post@rolandgruber.de>} [src:ldap-account=
-manager] ldap-account-manager: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047401 to the same values=
 previously set
> notfixed 1047422 1.0.2.6-4
Bug #1047422 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-lrdragndrop] python-xstatic-angular-lrdragndrop: Fails to build sour=
ce after successful build
Ignoring request to alter fixed versions of bug #1047422 to the same values=
 previously set
> notfixed 1047423 2.0.1.5+ds-1
Bug #1047423 {Done: Antonio Valentino <antonio.valentino@tiscali.it>} [src:=
pyerfa] pyerfa: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047423 to the same values=
 previously set
> notfixed 1047431 12.0.0-1
Bug #1047431 {Done: Thomas Goirand <zigo@debian.org>} [src:masakari-dashboa=
rd] masakari-dashboard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047431 to the same values=
 previously set
> notfixed 1047466 1:5.6.0-2
Bug #1047466 {Done: Thomas Goirand <zigo@debian.org>} [src:python-keystonec=
lient] python-keystoneclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047466 to the same values=
 previously set
> notfixed 1047472 7.1.0-4
Bug #1047472 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.log]=
 python-oslo.log: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047472 to the same values=
 previously set
> notfixed 1047478 1.2.23.1-10
Bug #1047478 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-mock] python-xstatic-angular-mock: Fails to build source after succe=
ssful build
Ignoring request to alter fixed versions of bug #1047478 to the same values=
 previously set
> notfixed 1047482 1:20.0.0-3
Bug #1047482 {Done: Thomas Goirand <zigo@debian.org>} [src:manila] manila: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047482 to the same values=
 previously set
> notfixed 1047490 0.2-1
Bug #1047490 {Done: Jelmer Vernoo=C4=B3 <jelmer@jelmer.uk>} [src:python-fas=
tbencode] python-fastbencode: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047490 to the same values=
 previously set
> notfixed 1047493 3.2.0+dfsg-2
Bug #1047493 {Done: Andreas Tille <tille@debian.org>} [src:r-bioc-rhtslib] =
r-bioc-rhtslib: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047493 to the same values=
 previously set
> notfixed 1047498 4.1.0-3
Bug #1047498 {Done: Thomas Goirand <zigo@debian.org>} [src:python-fixtures]=
 python-fixtures: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047498 to the same values=
 previously set
> notfixed 1047502 0.1.13-23
Bug #1047502 {Done: Ralf Treinen <treinen@debian.org>} [src:planets] planet=
s: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047502 to the same values=
 previously set
> notfixed 1047524 1:23.0.0-2
Bug #1047524 {Done: Thomas Goirand <zigo@debian.org>} [src:openstack-trove]=
 openstack-trove: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047524 to the same values=
 previously set
> notfixed 1047547 1.2.8.0+dfsg1-6
Bug #1047547 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-s=
pin] python-xstatic-spin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047547 to the same values=
 previously set
> notfixed 1047555 3.5.1.1-4
Bug #1047555 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query] python-xstatic-jquery: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047555 to the same values=
 previously set
> notfixed 1047562 2.2.1+dfsg-3
Bug #1047562 {Done: Picca Fr=C3=A9d=C3=A9ric-Emmanuel <picca@debian.org>} [=
src:silx] silx: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047562 to the same values=
 previously set
> notfixed 1047573 4.0.0-8
Bug #1047573 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pymemcach=
e] python-pymemcache: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047573 to the same values=
 previously set
> notfixed 1047577 0.6-2
Bug #1047577 {Done: Nilesh Patra <nilesh@debian.org>} [src:nmodl] nmodl: Fa=
ils to build source after successful build
Ignoring request to alter fixed versions of bug #1047577 to the same values=
 previously set
> notfixed 1047597 1.3.2.0-4
Bug #1047597 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-f=
ilesaver] python-xstatic-filesaver: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1047597 to the same values=
 previously set
> notfixed 1047612 3.0.2-1
Bug #1047612 {Done: Michael R. Crusoe <crusoe@debian.org>} [src:macs] macs:=
 Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047612 to the same values=
 previously set
> notfixed 1047621 4.0.3+dfsg-1
Bug #1047621 {Done: Dima Kogan <dkogan@debian.org>} [src:notion] notion: Fa=
ils to build source after successful build
Ignoring request to alter fixed versions of bug #1047621 to the same values=
 previously set
> notfixed 1047643 1.2.41-1
Bug #1047643 {Done: Rene Engelhard <rene@debian.org>} [src:xmlsec1] xmlsec1=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047643 to the same values=
 previously set
> notfixed 1047663 1.1.0-4
Bug #1047663 {Done: Thomas Goirand <zigo@debian.org>} [src:python-mbstrdeco=
der] python-mbstrdecoder: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047663 to the same values=
 previously set
> notfixed 1047665 5.2.1-2
Bug #1047665 {Done: Thomas Goirand <zigo@debian.org>} [src:python-zunclient=
] python-zunclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047665 to the same values=
 previously set
> notfixed 1047688 0.2.2-8
Bug #1047688 {Done: Thomas Goirand <zigo@debian.org>} [src:python-zake] pyt=
hon-zake: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047688 to the same values=
 previously set
> notfixed 1047705 0.10.0-8
Bug #1047705 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pykmip] p=
ython-pykmip: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047705 to the same values=
 previously set
> notfixed 1047724 1.3.2-1
Bug #1047724 {Done: Picca Fr=C3=A9d=C3=A9ric-Emmanuel <picca@debian.org>} [=
src:python-fisx] python-fisx: Fails to build source after successful build
No longer marked as fixed in versions python-fisx/1.3.2-1.
> notfixed 1047735 12.0.0-1
Bug #1047735 {Done: Thomas Goirand <zigo@debian.org>} [src:neutron-vpnaas-d=
ashboard] neutron-vpnaas-dashboard: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1047735 to the same values=
 previously set
> notfixed 1047738 1.6.10-2
Bug #1047738 {Done: Thomas Goirand <zigo@debian.org>} [src:python-yappi] py=
thon-yappi: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047738 to the same values=
 previously set
> notfixed 1047747 4.6.0-2
Bug #1047747 {Done: Thomas Goirand <zigo@debian.org>} [src:python-osc-place=
ment] python-osc-placement: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047747 to the same values=
 previously set
> notfixed 1047756 4.1.0-3
Bug #1047756 {Done: Thomas Goirand <zigo@debian.org>} [src:python-stestr] p=
ython-stestr: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047756 to the same values=
 previously set
> notfixed 1047769 3.10.1+dfsg1-4
Bug #1047769 {Done: Drew Parsons <dparsons@debian.org>} [src:matplotlib] ma=
tplotlib: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047769 to the same values=
 previously set
> notfixed 1047790 0.15.1-1
Bug #1047790 {Done: Martin <debacle@debian.org>} [src:poezio] poezio: Fails=
 to build source after successful build
Ignoring request to alter fixed versions of bug #1047790 to the same values=
 previously set
> notfixed 1047791 0.0.0.1-9
Bug #1047791 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-b=
ootstrap-datepicker] python-xstatic-bootstrap-datepicker: Fails to build so=
urce after successful build
Ignoring request to alter fixed versions of bug #1047791 to the same values=
 previously set
> notfixed 1047792 3.1.0-6
Bug #1047792 {Done: Thomas Goirand <zigo@debian.org>} [src:python-dracclien=
t] python-dracclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047792 to the same values=
 previously set
> notfixed 1047819 5.9.0-7
Bug #1047819 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-win] p=
ython-os-win: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047819 to the same values=
 previously set
> notfixed 1047823 4.5.0-2
Bug #1047823 {Done: F=C3=A9lix Sipma <felix@debian.org>} [src:todoman] todo=
man: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047823 to the same values=
 previously set
> notfixed 1047826 1.32-5
Bug #1047826 {Done: Thomas Goirand <zigo@debian.org>} [src:python-json-patc=
h] python-json-patch: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047826 to the same values=
 previously set
> notfixed 1047834 0.8.0+dfsg-3.1
Bug #1047834 {Done: Gard Spreemann <gspr@nonempty.org>} [src:python-pyspike=
] python-pyspike: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047834 to the same values=
 previously set
> notfixed 1047835 2.11.0-2
Bug #1047835 {Done: Thomas Goirand <zigo@debian.org>} [src:neutron-tempest-=
plugin] neutron-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047835 to the same values=
 previously set
> notfixed 1047884 5.1.0-1
Bug #1047884 {Done: Picca Fr=C3=A9d=C3=A9ric-Emmanuel <picca@debian.org>} [=
src:python-hdf5plugin] python-hdf5plugin: Fails to build source after succe=
ssful build
Ignoring request to alter fixed versions of bug #1047884 to the same values=
 previously set
> notfixed 1047898 4.2.2-1
Bug #1047898 {Done: Helge Kreutzmann <debian@helgefjell.de>} [src:linuxinfo=
] linuxinfo: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047898 to the same values=
 previously set
> notfixed 1047901 4.1-1
Bug #1047901 {Done: Jeroen Ploemen <jcfp@debian.org>} [src:re2c] re2c: Fail=
s to build source after successful build
Ignoring request to alter fixed versions of bug #1047901 to the same values=
 previously set
> notfixed 1047930 0.17-1
Bug #1047930 {Done: Alberto Bertogli <albertito@blitiri.com.ar>} [src:kxd] =
kxd: Fails to build source after successful build
No longer marked as fixed in versions 0.17-1.
> notfixed 1047937 1.24.11+ds-5
Bug #1047937 {Done: Doug Torrance <dtorrance@debian.org>} [src:macaulay2] m=
acaulay2: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047937 to the same values=
 previously set
> notfixed 1047946 1.1.0-1
Bug #1047946 {Done: Andreas Tille <tille@debian.org>} [src:vramsteg] vramst=
eg: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047946 to the same values=
 previously set
> notfixed 1047954 13.02.00-1
Bug #1047954 {Done: tony mancill <tmancill@debian.org>} [src:icmake] icmake=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047954 to the same values=
 previously set
> notfixed 1047961 0.42-1
Bug #1047961 {Done: Dima Kogan <dkogan@debian.org>} [src:python-numpysane] =
python-numpysane: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047961 to the same values=
 previously set
> notfixed 1047969 3.5.1-1
Bug #1047969 {Done: Thomas Goirand <zigo@debian.org>} [src:python-tempestco=
nf] python-tempestconf: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1047969 to the same values=
 previously set
> notfixed 1048006 0.10.0-4
Bug #1048006 {Done: Lance Lin <lq27267@gmail.com>} [src:python-pybedtools] =
python-pybedtools: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048006 to the same values=
 previously set
> notfixed 1048007 1.17.0+dfsg-1
Bug #1048007 {Done: Andreas Tille <tille@debian.org>} [src:r-cran-data.tabl=
e] r-cran-data.table: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048007 to the same values=
 previously set
> notfixed 1048014 5.3.1-3
Bug #1048014 {Done: Thomas Goirand <zigo@debian.org>} [src:python-cloudkitt=
yclient] python-cloudkittyclient: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1048014 to the same values=
 previously set
> notfixed 1048018 2.9.5+dfsg-1
Bug #1048018 {Done: Timo R=C3=B6hling <roehling@debian.org>} [src:tinygltf]=
 tinygltf: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048018 to the same values=
 previously set
> notfixed 1048019 3.5.3-2
Bug #1048019 {Done: J=C3=A9r=C3=B4me Charaoui <jerome@riseup.net>} [src:ssl=
-utils-clojure] ssl-utils-clojure: Fails to build source after successful b=
uild
Ignoring request to alter fixed versions of bug #1048019 to the same values=
 previously set
> notfixed 1048023 4.4.3-5
Bug #1048023 {Done: Emmanuel Arias <eamanu@debian.org>} [src:python-hpilo] =
python-hpilo: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048023 to the same values=
 previously set
> notfixed 1048034 2.6.1-3
Bug #1048034 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.limi=
t] python-oslo.limit: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048034 to the same values=
 previously set
> notfixed 1048047 8.2.6-1
Bug #1048047 {Done: Nilesh Patra <nilesh@debian.org>} [src:neuron] neuron: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048047 to the same values=
 previously set
> notfixed 1048050 16.1.0-3
Bug #1048050 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.mess=
aging] python-oslo.messaging: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048050 to the same values=
 previously set
> notfixed 1048053 20.0.0-2
Bug #1048053 {Done: Thomas Goirand <zigo@debian.org>} [src:magnum] magnum: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048053 to the same values=
 previously set
> notfixed 1048055 0.1.10-7
Bug #1048055 {Done: Thomas Goirand <zigo@debian.org>} [src:python-termstyle=
] python-termstyle: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048055 to the same values=
 previously set
> notfixed 1048056 7.0.0-2
Bug #1048056 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ironic-li=
b] python-ironic-lib: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048056 to the same values=
 previously set
> notfixed 1048066 1.1.4-1
Bug #1048066 {Done: A. Maitland Bottoms <bottoms@debian.org>} [src:log4cpp]=
 log4cpp: Fails to build source after successful build
No longer marked as fixed in versions log4cpp/1.1.4-1.
> notfixed 1048082 1.2-3
Bug #1048082 {Done: Chris Lamb <lamby@debian.org>} [src:libfiu] libfiu: Fai=
ls to build source after successful build
Ignoring request to alter fixed versions of bug #1048082 to the same values=
 previously set
> notfixed 1048091 2.5.0.0-4
Bug #1048091 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-bootstrap] python-xstatic-angular-bootstrap: Fails to build source a=
fter successful build
Ignoring request to alter fixed versions of bug #1048091 to the same values=
 previously set
> notfixed 1048114 3.20+git20240209.8710add+dfsg2-1
Bug #1048114 {Done: Xiyue Deng <manphiz@gmail.com>} [src:muse-el] muse-el: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048114 to the same values=
 previously set
> notfixed 1048134 1.4.0-7
Bug #1048134 {Done: Thomas Goirand <zigo@debian.org>} [src:python-jsonpath-=
rw] python-jsonpath-rw: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048134 to the same values=
 previously set
> notfixed 1048141 1.85.0+dfsg3-1
Bug #1048141 {Done: Fabian Gr=C3=BCnbichler <debian@fabian.gruenbichler.ema=
il>} [src:rustc] rustc: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048141 to the same values=
 previously set
> notfixed 1048142 14.0.0-1+deb13u1
Bug #1048142 {Done: Thomas Goirand <zigo@debian.org>} [src:watcher] watcher=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048142 to the same values=
 previously set
> notfixed 1048154 5.2.1+ds1-4
Bug #1048154 {Done: Roland Mas <lolando@debian.org>} [src:jupyterhub] jupyt=
erhub: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048154 to the same values=
 previously set
> notfixed 1048157 0.4.17.0-5
Bug #1048157 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-d=
agre-d3] python-xstatic-dagre-d3: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1048157 to the same values=
 previously set
> notfixed 1048161 1.5.0-1
Bug #1048161 {Done: Gunnar Hjalmarsson <gunnarhj@debian.org>} [src:ibus-inp=
ut-pad] ibus-input-pad: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048161 to the same values=
 previously set
> notfixed 1048175 16.0.0-2
Bug #1048175 {Done: Thomas Goirand <zigo@debian.org>} [src:octavia] octavia=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048175 to the same values=
 previously set
> notfixed 1048179 3.3.7.0-7
Bug #1048179 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-b=
ootswatch] python-xstatic-bootswatch: Fails to build source after successfu=
l build
Ignoring request to alter fixed versions of bug #1048179 to the same values=
 previously set
> notfixed 1048182 2.0.0+20231128.d725c81-1
Bug #1048182 {Done: Martin <debacle@debian.org>} [src:libxeddsa] libxeddsa:=
 Fails to build source after successful build
No longer marked as fixed in versions libxeddsa/2.0.0+20231128.d725c81-1.
> notfixed 1048183 0.4.2-1
Bug #1048183 {Done: Anibal Monsalve Salazar <anibal@debian.org>} [src:nfs4-=
acl-tools] nfs4-acl-tools: Fails to build source after successful build
No longer marked as fixed in versions nfs4-acl-tools/0.4.2-1.
> notfixed 1048187 22.0.0-1
Bug #1048187 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-bgpvp=
n] networking-bgpvpn: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048187 to the same values=
 previously set
> notfixed 1048194 2.8.0-4
Bug #1048194 {Done: Thomas Goirand <zigo@debian.org>} [src:python-monascacl=
ient] python-monascaclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048194 to the same values=
 previously set
> notfixed 1048215 2.12.0-2
Bug #1048215 {Done: Thomas Goirand <zigo@debian.org>} [src:python-tosca-par=
ser] python-tosca-parser: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048215 to the same values=
 previously set
> notfixed 1048218 1:8.8.0-2
Bug #1048218 {Done: Thomas Goirand <zigo@debian.org>} [src:python-troveclie=
nt] python-troveclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048218 to the same values=
 previously set
> notfixed 1048219 2.1.1-4
Bug #1048219 {Done: Thomas Goirand <zigo@debian.org>} [src:python-searchlig=
htclient] python-searchlightclient: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1048219 to the same values=
 previously set
> notfixed 1048225 1.3.15-2
Bug #1048225 {Done: Maarten L. Hekkelman <maarten@hekkelman.com>} [src:mrc]=
 mrc: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048225 to the same values=
 previously set
> notfixed 1048236 1.2.1.0-7
Bug #1048236 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-o=
bjectpath] python-xstatic-objectpath: Fails to build source after successfu=
l build
Ignoring request to alter fixed versions of bug #1048236 to the same values=
 previously set
> notfixed 1048256 20.0.0-2
Bug #1048256 {Done: Thomas Goirand <zigo@debian.org>} [src:mistral] mistral=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048256 to the same values=
 previously set
> notfixed 1048262 0.2.9-8
Bug #1048262 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xvfbwrapp=
er] python-xvfbwrapper: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048262 to the same values=
 previously set
> notfixed 1048274 0.5-6
Bug #1048274 {Done: Emmanuel Arias <eamanu@debian.org>} [src:python-plaster=
-pastedeploy] python-plaster-pastedeploy: Fails to build source after succe=
ssful build
No longer marked as fixed in versions python-plaster-pastedeploy/0.5-6.
> notfixed 1048286 2.13.0-2
Bug #1048286 {Done: Thomas Goirand <zigo@debian.org>} [src:ironic-tempest-p=
lugin] ironic-tempest-plugin: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048286 to the same values=
 previously set
> notfixed 1048287 6.1.0-1
Bug #1048287 {Done: Tommi H=C3=B6yn=C3=A4l=C3=A4nmaa <tommi.hoynalanmaa@iki=
.fi>} [src:theme-d] theme-d: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048287 to the same values=
 previously set
> notfixed 1048301 4.7.0.0-8
Bug #1048301 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-f=
ont-awesome] python-xstatic-font-awesome: Fails to build source after succe=
ssful build
Ignoring request to alter fixed versions of bug #1048301 to the same values=
 previously set
> notfixed 1048337 6.11.0-2
Bug #1048337 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-brick]=
 python-os-brick: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048337 to the same values=
 previously set
> notfixed 1048352 3.10.0-2
Bug #1048352 {Done: Thomas Goirand <zigo@debian.org>} [src:python-octaviacl=
ient] python-octaviaclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048352 to the same values=
 previously set
> notfixed 1048388 15.0.0-1
Bug #1048388 {Done: Thomas Goirand <zigo@debian.org>} [src:neutron-taas] ne=
utron-taas: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048388 to the same values=
 previously set
> notfixed 1048393 2.0.2+dfsg-12
Bug #1048393 {Done: =C3=89tienne Mollier <emollier@debian.org>} [src:pirs] =
pirs: Fails to build source after successful build
No longer marked as fixed in versions pirs/2.0.2+dfsg-12.
> notfixed 1048405 1.7.2-4
Bug #1048405 {Done: Thomas Goirand <zigo@debian.org>} [src:python-ddt] pyth=
on-ddt: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048405 to the same values=
 previously set
> notfixed 1048416 2:26.0.0-9
Bug #1048416 {Done: Thomas Goirand <zigo@debian.org>} [src:neutron] neutron=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048416 to the same values=
 previously set
> notfixed 1048418 1.0.1-6
Bug #1048418 {Done: Thomas Goirand <zigo@debian.org>} [src:python-calmjs.ty=
pes] python-calmjs.types: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048418 to the same values=
 previously set
> notfixed 1048426 1:5.0.0-4
Bug #1048426 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslotest]=
 python-oslotest: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048426 to the same values=
 previously set
> notfixed 1048427 0.10.0-4
Bug #1048427 {Done: Jonas Smedegaard <dr@jones.dk>} [src:sccache] sccache: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048427 to the same values=
 previously set
> notfixed 1048428 0.18.0-2
Bug #1048428 {Done: Thomas Goirand <zigo@debian.org>} [src:keystone-tempest=
-plugin] keystone-tempest-plugin: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1048428 to the same values=
 previously set
> notfixed 1048440 4.9.1-2
Bug #1048440 {Done: Thomas Goirand <zigo@debian.org>} [src:python-glance-st=
ore] python-glance-store: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048440 to the same values=
 previously set
> notfixed 1048443 2.18.5+dfsg-1
Bug #1048443 {Done: Pierre Gruet <pgt@debian.org>} [src:igv] igv: Fails to =
build source after successful build
Ignoring request to alter fixed versions of bug #1048443 to the same values=
 previously set
> notfixed 1048472 1.7.1-1
Bug #1048472 {Done: Thorsten Alteholz <debian@alteholz.de>} [src:osmo-trx] =
osmo-trx: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048472 to the same values=
 previously set
> notfixed 1048476 15.0.0-1
Bug #1048476 {Done: Thomas Goirand <zigo@debian.org>} [src:octavia-dashboar=
d] octavia-dashboard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048476 to the same values=
 previously set
> notfixed 1048486 0.4.0+2016.05.20.git.40ee44c664-7
Bug #1048486 {Done: Thomas Goirand <zigo@debian.org>} [src:python-seamicroc=
lient] python-seamicroclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048486 to the same values=
 previously set
> notfixed 1048503 8.6.0-2
Bug #1048503 {Done: Thomas Goirand <zigo@debian.org>} [src:python-masakaric=
lient] python-masakariclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048503 to the same values=
 previously set
> notfixed 1048514 0.16.0-3
Bug #1048514 {Done: Thomas Goirand <zigo@debian.org>} [src:python-scciclien=
t] python-scciclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048514 to the same values=
 previously set
> notfixed 1048539 4.8.0-2
Bug #1048539 {Done: Thomas Goirand <zigo@debian.org>} [src:python-watchercl=
ient] python-watcherclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048539 to the same values=
 previously set
> notfixed 1048599 2.3.0-1
Bug #1048599 {Done: Julien Puydt <jpuydt@debian.org>} [src:mathcomp-multino=
mials] mathcomp-multinomials: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048599 to the same values=
 previously set
> notfixed 1048605 2.1.0-3
Bug #1048605 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-client=
-config] python-os-client-config: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1048605 to the same values=
 previously set
> notfixed 1048629 6.2.2501+dfsg1-12
Bug #1048629 {Done: Drew Parsons <dparsons@debian.org>} [src:netgen] netgen=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048629 to the same values=
 previously set
> notfixed 1048647 1.4.0-2
Bug #1048647 {Done: ChangZhuo Chen (=E9=99=B3=E6=98=8C=E5=80=AC) <czchen@de=
bian.org>} [src:libfm] libfm: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048647 to the same values=
 previously set
> notfixed 1048652 1.4.309.0-1
Bug #1048652 {Done: Timo Aaltonen <tjaalton@debian.org>} [src:vulkan-loader=
] vulkan-loader: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048652 to the same values=
 previously set
> notfixed 1048685 2.0.2-5
Bug #1048685 {Done: Thomas Goirand <zigo@debian.org>} [src:python-pydotplus=
] python-pydotplus: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048685 to the same values=
 previously set
> notfixed 1048692 2.0.11-1
Bug #1048692 {Done: Christian Marillat <marillat@debian.org>} [src:libtorre=
nt-rasterbar] libtorrent-rasterbar: Fails to build source after successful =
build
Ignoring request to alter fixed versions of bug #1048692 to the same values=
 previously set
> notfixed 1048709 5.4.0-2
Bug #1048709 {Done: Thomas Goirand <zigo@debian.org>} [src:python-manilacli=
ent] python-manilaclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048709 to the same values=
 previously set
> notfixed 1048725 0.9.0+ds-1
Bug #1048725 {Done: Andreas Tille <tille@debian.org>} [src:python-http-pars=
er] python-http-parser: Fails to build source after successful build
No longer marked as fixed in versions python-http-parser/0.9.0+ds-1.
> notfixed 1048743 5.15.15+dfsg-6
Bug #1048743 {Done: Dmitry Shachnev <mitya57@debian.org>} [src:qtbase-opens=
ource-src] qtbase-opensource-src: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1048743 to the same values=
 previously set
> notfixed 1048747 12.2.13.0+dfsg1-4
Bug #1048747 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-fileupload] python-xstatic-angular-fileupload: Fails to build source=
 after successful build
Ignoring request to alter fixed versions of bug #1048747 to the same values=
 previously set
> notfixed 1048752 1:2.0.4+git20150213-3
Bug #1048752 {Done: Mateusz =C5=81ukasik <mati75@linuxmint.pl>} [src:obconf=
] obconf: Fails to build source after successful build
No longer marked as fixed in versions obconf/1:2.0.4+git20150213-3.
> notfixed 1048754 2:4.22.6+dfsg-0+deb13u1
Bug #1048754 {Done: Michael Tokarev <mjt@tls.msk.ru>} [src:samba] samba: Fa=
ils to build source after successful build
Ignoring request to alter fixed versions of bug #1048754 to the same values=
 previously set
> notfixed 1048765 22.0.0-1
Bug #1048765 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-bagpi=
pe] networking-bagpipe: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048765 to the same values=
 previously set
> notfixed 1048778 0.2.5.1-6
Bug #1048778 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-m=
agic-search] python-xstatic-magic-search: Fails to build source after succe=
ssful build
Ignoring request to alter fixed versions of bug #1048778 to the same values=
 previously set
> notfixed 1048798 5.1.3+dfsg-3
Bug #1048798 {Done: Juli=C3=A1n Moreno Pati=C3=B1o <julian@debian.org>} [sr=
c:texmaker] texmaker: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048798 to the same values=
 previously set
> notfixed 1048810 0.1.3-4
Bug #1048810 {Done: Gianfranco Costamagna <locutusofborg@debian.org>} [src:=
python-vulndb] python-vulndb: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048810 to the same values=
 previously set
> notfixed 1048819 1.6-7
Bug #1048819 {Done: Thomas Goirand <zigo@debian.org>} [src:sixer] sixer: Fa=
ils to build source after successful build
Ignoring request to alter fixed versions of bug #1048819 to the same values=
 previously set
> notfixed 1048850 4.1.0-4
Bug #1048850 {Done: Thomas Goirand <zigo@debian.org>} [src:python-hacking] =
python-hacking: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048850 to the same values=
 previously set
> notfixed 1048856 1.3+dfsg1-2
Bug #1048856 {Done: Georges Khaznadar <georgesk@debian.org>} [src:pampi] pa=
mpi: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048856 to the same values=
 previously set
> notfixed 1048907 5.2.2-6
Bug #1048907 {Done: Hilko Bengen <bengen@debian.org>} [src:supermin] superm=
in: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048907 to the same values=
 previously set
> notfixed 1048912 0.56.0-1
Bug #1048912 {Done: Anton Gladky <gladk@debian.org>} [src:pyftdi] pyftdi: F=
ails to build source after successful build
No longer marked as fixed in versions pyftdi/0.56.0-1.
> notfixed 1048932 2.0.14-5
Bug #1048932 {Done: Scott Kitterman <scott@kitterman.com>} [src:pyspf] pysp=
f: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048932 to the same values=
 previously set
> notfixed 1048936 6.0.26+ds-1.1
Bug #1048936 {Done: Antonio Terceiro <terceiro@debian.org>} [src:passenger]=
 passenger: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048936 to the same values=
 previously set
> notfixed 1048943 5.7.1-3
Bug #1048943 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.cont=
ext] python-oslo.context: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048943 to the same values=
 previously set
> notfixed 1048944 0.0~git20241223.ea91db2-1
Bug #1048944 {Done: Michael R. Crusoe <crusoe@debian.org>} [src:typeshed] t=
ypeshed: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048944 to the same values=
 previously set
> notfixed 1048948 4.1.2.3-4
Bug #1048948 {Done: Mike Gabriel <sunweaver@debian.org>} [src:x2goclient] x=
2goclient: Fails to build source after successful build
No longer marked as fixed in versions x2goclient/4.1.2.3-4.
> notfixed 1048957 4.3.0-2
Bug #1048957 {Done: Thomas Goirand <zigo@debian.org>} [src:python-blazarcli=
ent] python-blazarclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048957 to the same values=
 previously set
> notfixed 1048972 3.5.1-3
Bug #1048972 {Done: Thomas Goirand <zigo@debian.org>} [src:python-oslo.repo=
rts] python-oslo.reports: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048972 to the same values=
 previously set
> notfixed 1048988 1:21.0.0-1
Bug #1048988 {Done: Thomas Goirand <zigo@debian.org>} [src:networking-l2gw]=
 networking-l2gw: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048988 to the same values=
 previously set
> notfixed 1048995 3.7.1-2
Bug #1048995 {Done: Thomas Goirand <zigo@debian.org>} [src:python-aodhclien=
t] python-aodhclient: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1048995 to the same values=
 previously set
> notfixed 1049005 2.0.0.2-6
Bug #1049005 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-h=
ogan] python-xstatic-hogan: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049005 to the same values=
 previously set
> notfixed 1049006 4.1.0-2
Bug #1049006 {Done: Thomas Goirand <zigo@debian.org>} [src:python-os-vif] p=
ython-os-vif: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049006 to the same values=
 previously set
> notfixed 1049009 5.2.1-2
Bug #1049009 {Done: Thomas Goirand <zigo@debian.org>} [src:python-castellan=
] python-castellan: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049009 to the same values=
 previously set
> notfixed 1049013 1.4.1-1
Bug #1049013 {Done: Phil Wyett <philip.wyett@kathenas.org>} [src:sep] sep: =
Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049013 to the same values=
 previously set
> notfixed 1049042 2.7.0-4
Bug #1049042 {Done: Thomas Goirand <zigo@debian.org>} [src:python-monasca-s=
tatsd] python-monasca-statsd: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049042 to the same values=
 previously set
> notfixed 1049051 20.0.0-1
Bug #1049051 {Done: Thomas Goirand <zigo@debian.org>} [src:mistral-dashboar=
d] mistral-dashboard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049051 to the same values=
 previously set
> notfixed 1049053 19.0.0-3
Bug #1049053 {Done: Thomas Goirand <zigo@debian.org>} [src:masakari] masaka=
ri: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049053 to the same values=
 previously set
> notfixed 1049054 1.2.24.1-7
Bug #1049054 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-cookies] python-xstatic-angular-cookies: Fails to build source after=
 successful build
Ignoring request to alter fixed versions of bug #1049054 to the same values=
 previously set
> notfixed 1049076 6.09+dfsg1-1
Bug #1049076 {Done: Tormod Volden <debian.tormod@gmail.com>} [src:xscreensa=
ver] xscreensaver: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049076 to the same values=
 previously set
> notfixed 1049109 4.6.1732034221.ae34b08ff-2
Bug #1049109 {Done: Philip Hands <phil@hands.com>} [src:openqa] openqa: Fai=
ls to build source after successful build
Ignoring request to alter fixed versions of bug #1049109 to the same values=
 previously set
> notfixed 1049125 1.0.0.1-6
Bug #1049125 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
query.bootstrap.wizard] python-xstatic-jquery.bootstrap.wizard: Fails to bu=
ild source after successful build
Ignoring request to alter fixed versions of bug #1049125 to the same values=
 previously set
> notfixed 1049163 24.0.0-1
Bug #1049163 {Done: Thomas Goirand <zigo@debian.org>} [src:trove-dashboard]=
 trove-dashboard: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049163 to the same values=
 previously set
> notfixed 1049177 2.2.0-3
Bug #1049177 {Done: Andrej Shadura <andrewsh@debian.org>} [src:lavacli] lav=
acli: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049177 to the same values=
 previously set
> notfixed 1049189 0.3.1.2-5
Bug #1049189 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-ui-router] python-xstatic-angular-ui-router: Fails to build source a=
fter successful build
Ignoring request to alter fixed versions of bug #1049189 to the same values=
 previously set
> notfixed 1049198 5.15.15+dfsg-2
Bug #1049198 {Done: Dmitry Shachnev <mitya57@debian.org>} [src:qtbase-opens=
ource-src-gles] qtbase-opensource-src-gles: Fails to build source after suc=
cessful build
Ignoring request to alter fixed versions of bug #1049198 to the same values=
 previously set
> notfixed 1049216 2.1.7.0-5
Bug #1049216 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-g=
raphlib] python-xstatic-graphlib: Fails to build source after successful bu=
ild
Ignoring request to alter fixed versions of bug #1049216 to the same values=
 previously set
> notfixed 1049217 13.0.0-1
Bug #1049217 {Done: Thomas Goirand <zigo@debian.org>} [src:placement] place=
ment: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049217 to the same values=
 previously set
> notfixed 1049230 5.3.0-3
Bug #1049230 {Done: St=C3=A9phane Glondu <glondu@debian.org>} [src:ocaml] o=
caml: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049230 to the same values=
 previously set
> notfixed 1049233 0.8.13.0-7
Bug #1049233 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-a=
ngular-schema-form] python-xstatic-angular-schema-form: Fails to build sour=
ce after successful build
Ignoring request to alter fixed versions of bug #1049233 to the same values=
 previously set
> notfixed 1049242 2.6.1-1
Bug #1049242 {Done: Pierre Neyron <pierre.neyron@free.fr>} [src:oar] oar: F=
ails to build source after successful build
Ignoring request to alter fixed versions of bug #1049242 to the same values=
 previously set
> notfixed 1049246 3.2.6-1
Bug #1049246 {Done: Carsten Schoenert <c.schoenert@t-online.de>} [src:psyco=
pg3] psycopg3: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049246 to the same values=
 previously set
> notfixed 1049262 3.8.1.0-4
Bug #1049262 {Done: Thomas Goirand <zigo@debian.org>} [src:python-xstatic-j=
s-yaml] python-xstatic-js-yaml: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049262 to the same values=
 previously set
> notfixed 1049271 8.6+repack-5
Bug #1049271 {Done: Ole Streicher <olebole@debian.org>} [src:saods9] saods9=
: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049271 to the same values=
 previously set
> notfixed 1049288 3.2.0-3
Bug #1049288 {Done: Thomas Goirand <zigo@debian.org>} [src:python-automaton=
] python-automaton: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049288 to the same values=
 previously set
> notfixed 1049293 0.7.0+git20240416.9d2b3b3+ds1-3
Bug #1049293 {Done: Reinhard Tartler <siretart@tauware.de>} [src:notary] no=
tary: Fails to build source after successful build
Ignoring request to alter fixed versions of bug #1049293 to the same values=
 previously set
> notfixed 1049307 2.0.0-2
Bug #1049307 {Done: Thomas Goirand <zigo@debian.org>} [src:python-sphinx-fe=
ature-classification] python-sphinx-feature-classification: Fails to build =
source after successful build
Ignoring request to alter fixed versions of bug #1049307 to the same values=
 previously set
> notfixed 1049315 4.3.2-1
Bug #1049315 {Done: Bdale Garbee <bdale@gag.com>} [src:librnd] librnd: Fail=
s to build source after successful build
Ignoring request to alter fixed versions of bug #1049315 to the same values=
 previously set
> thanks
Stopping processing here.

Please contact me if you need assistance.
--=20
1043628: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043628
1043642: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043642
1043647: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043647
1043650: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043650
1043669: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043669
1043695: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043695
1043705: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043705
1043723: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043723
1043725: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043725
1043780: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1043780
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
1044028: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044028
1044048: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044048
1044090: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044090
1044094: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044094
1044103: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044103
1044109: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044109
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
1044886: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044886
1044915: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044915
1044922: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044922
1044936: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044936
1044979: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044979
1044981: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044981
1044992: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1044992
1045001: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045001
1045029: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045029
1045047: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045047
1045073: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045073
1045076: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045076
1045085: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045085
1045093: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045093
1045112: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045112
1045122: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045122
1045134: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045134
1045142: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045142
1045150: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045150
1045152: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045152
1045153: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045153
1045155: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045155
1045158: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045158
1045170: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045170
1045186: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045186
1045198: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045198
1045213: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045213
1045222: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045222
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
1045732: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045732
1045748: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045748
1045749: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045749
1045759: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045759
1045761: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045761
1045771: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045771
1045774: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045774
1045775: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045775
1045791: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045791
1045808: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045808
1045814: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045814
1045818: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045818
1045822: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045822
1045869: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1045869
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
1046169: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046169
1046172: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046172
1046175: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046175
1046176: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046176
1046201: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046201
1046221: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046221
1046222: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046222
1046233: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046233
1046238: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046238
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
1046430: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046430
1046444: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046444
1046451: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046451
1046459: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046459
1046467: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046467
1046493: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046493
1046499: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046499
1046505: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046505
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
1046789: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046789
1046791: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046791
1046813: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046813
1046816: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046816
1046832: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046832
1046843: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046843
1046849: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046849
1046864: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046864
1046902: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046902
1046913: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046913
1046915: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046915
1046921: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046921
1046931: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046931
1046957: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046957
1046966: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046966
1046977: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046977
1046994: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046994
1046999: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1046999
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
1047555: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047555
1047562: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047562
1047573: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1047573
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
1048388: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048388
1048393: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048393
1048396: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048396
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
1048514: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048514
1048539: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048539
1048599: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048599
1048605: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048605
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
1048765: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048765
1048778: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048778
1048798: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048798
1048810: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048810
1048819: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048819
1048850: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1048850
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
1049042: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049042
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
