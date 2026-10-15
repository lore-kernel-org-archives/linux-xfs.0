Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9782F38DD3;
	Thu, 15 Oct 2026 00:52:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792025550; cv=none; b=hXUF6/2Vq7fjzzSjaa5cAZKxw5oa243djFbl1wYiEXoKHNmoOhU1juF4mh5Wy3H4BUkljGqRQlvSi8kDreaSEIrRKiFOtVmV381YUkpnFybvyTy2bBDFQyPYPwIqZsBptbLqcweXlPf5etyjqx16DrBA6aFTBmgrGWDGg/glSCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792025550; c=relaxed/simple;
	bh=Jzg+X/M/fsnwex4H9TzBBmuIrxwLv+uXlZOsZmbydZc=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jhtNHVv1WeXumyI5sxDexXpvddYfzBl60wX4uVBeIdP07xPyDXOr/MYQ9N7JrnOWvHB/t5F9KvD3WwEOsq4D/ovHC2kmLq2t3EMsQMFCezwLcEgqmtvFBi0YI1xCZKdxxAKV/qs7Pb4Amp26zc0D/v3W/0rY69mXszVGPMb/qQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SmDcNJro; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SmDcNJro"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 30CB31F000C4;
	Thu, 15 Oct 2026 00:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792025549;
	bh=i/4bjsslxM/ztE5vhTElKLQxcVIsHz/tfpJklWy8GNA=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References;
	b=SmDcNJrotdTKZh+ccazPsResb02SOr5TjfC66P8oNiwf/QmChfEVRAeRGRNMy9uu1
	 oFmHLZ9Ta0SXIKp9DJGg0+dXxJZSC3L1Dsq6uTLqRioc0me0Mk56yjaf+FXg90vhY8
	 DIOfJVYa/r/MCzEF6DHpHW0Z8zkYcj/G3EsapwZrYWh8Fy/z7mBOoggwAh53/K3SZ1
	 MU8GTQI5/9eMh6UivUqsvEaEVbi3n0TcZ7PFCTZI+61Xz2QqqSx4Aa0IRVY85zZlHy
	 Ve4FB7DAdKqvnEcgLvj7T/sK4WIgWlQDiIszHDh6gNzYz0OqKv1ilfFOyhlITPZDyk
	 pUhlKeWAe9eBw==
Date: Wed, 14 Oct 2026 17:52:28 -0700
Subject: [PATCH 5/6] matrix: create build system for all software
From: "Darrick J. Wong" <djwong@kernel.org>
To: zlang@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org, tytso@mit.edu, fstests@vger.kernel.org
Message-ID: <179202481275.3448668.7033093117010378273.stgit@frogsfrogsfrogs>
In-Reply-To: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
References: <179202481155.3448668.10918297235750961947.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Build all the software, now that we've added the components.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 matrix/Makefile |  208 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 matrix/README   |   11 +++
 2 files changed, 219 insertions(+)
 create mode 100644 matrix/Makefile
 create mode 100644 matrix/README


diff --git a/matrix/Makefile b/matrix/Makefile
new file mode 100644
index 00000000000000..23c4bc423a3f71
--- /dev/null
+++ b/matrix/Makefile
@@ -0,0 +1,208 @@
+#
+# Copyright (c) 2018-2026 Oracle
+#
+
+CFLAGS=-g -O3 -Wall
+
+package=fstmatrix
+
+# Various paths
+prefix = /usr
+exec_prefix = ${prefix}
+bin_dir = ${exec_prefix}/bin
+sbin_dir = ${exec_prefix}/sbin
+lib_dir = ${exec_prefix}/lib
+share_dir = ${exec_prefix}/share
+libexec_dir=${exec_prefix}/libexec
+home_dir=/home
+pkg_share_dir = ${share_dir}/${package}
+pkg_lib_dir = ${lib_dir}/${package}
+pkg_libexec_dir=${libexec_dir}/${package}
+man_dir = ${share_dir}/man
+man1_dir = ${man_dir}/man1
+man5_dir = ${man_dir}/man5
+man8_dir = ${man_dir}/man8
+etc_dir = /etc
+systemd_dir = ${lib_dir}/systemd
+systemd_service_dir = ${systemd_dir}/system
+systemd_sysusers_dir=$(lib_dir)/sysusers.d
+man1pages=$(patsubst %,%.1,$(progs))
+man5pages=$(patsubst %,%.5,$(conffiles))
+man8pages=$(patsubst %,%.8,$(sbinprogs))
+
+# Macro substitution
+badmacros=badmacros SEDMESS SEDBIGMESS printvars
+
+# Horrible macro that replaces make macros with their values, if the macro
+# is in the form %<macroname>% .  Arguments are as follows:
+#   input template file
+#   output file
+#   list of variables that should be replaced with whatever file they point to
+define SEDMESS
+@echo "   [sed] $1 $2"
+@rm -f $2
+@sed$(foreach V,$3, -e '/%$V%/r $($V)' -e '/%$V/d')$(foreach V,$(.VARIABLES),$(if $(filter-out $(badmacros),$V),$(if $(filter-out environment% default automatic, $(origin $V)), -e 's|%$V%|$($V)|g'))) < $1 > $2
+@chmod a-w $2
+endef
+
+# Same macro, but run each sed command individually.  Use this if the SEDMESS
+# macro fails due to argument count overflow
+define SEDBIGMESS
+@echo "   [sed] $1 $2"
+@rm -f $2
+@cat $1 > $2
+$(foreach V,$3,@sed -e '/%$V%/r $($V)' -e '/%$V/d' -i $2
+)
+$(foreach V,$(.VARIABLES),$(if $(filter-out $(badmacros),$V),$(if $(filter-out environment% default automatic, $(origin $V)),@sed -e 's|%$V%|$($V)|g' -i $2
+)))
+@chmod a-w $2
+endef
+
+%: %.in
+	$(call SEDMESS,$<,$@)
+
+fstmatrix_user=fstmatrix
+fstmatrix_home_dir=$(home_dir)/$(fstmatrix_user)
+fstmatrix_inst_dir=$(fstmatrix_home_dir)/latest
+
+bot_age=15	# days
+
+dashboard_fonts="Libertinus Serif", "Linux Libertine O", "Linux Libertine O External", "Baskerville", serif
+
+libprogs=\
+	database/upsert_test_run \
+	database/create_db \
+	database/create_views \
+	database/db \
+	database/find_new_tarballs \
+	database/query_checktime \
+	database/query_machines \
+	database/query_test_run \
+	database/stow_tarball \
+	database/stow_tarballs \
+	collector/receive_tarball \
+	database/query_all_test_runs \
+	database/query_recent_test_runs \
+	reporter/collect-all-results \
+	reporter/collect-results \
+	reporter/starttime \
+	reporter/copy-failure-info \
+	reporter/fingerprint-machine \
+	reporter/fingerprint-tests \
+	reporter/upload-all-results \
+	reporter/fstmatrix-reporter \
+	dashboard/stow_dashboard \
+	reporter/fstmatrix-want-reporter \
+	database/test_runtime \
+	database/archive \
+	dashboard/create_dashboard \
+	collector/create_collector
+
+progs=\
+	reporter/fstests-reporter
+
+sbinprogs=\
+	dashboard/config-fstests-dashboard \
+	collector/create-fstests-collector
+
+libfiles=\
+	database/database.sql \
+	database/index.sql \
+	database/views.sql \
+	reporter/xunit_failed.awk \
+	reporter/xunit_rollup.awk \
+	database/fstestdb.py \
+
+service_files=\
+	collector/fstmatrix-receive.service \
+	collector/fstmatrix-receive.socket \
+	collector/fstmatrix-stow.service \
+	collector/fstmatrix-stow.timer \
+	reporter/fstmatrix-reporter.service \
+	reporter/fstmatrix-reporter.timer \
+	dashboard/fstmatrix-dashboard.service
+
+sysusers_files=\
+	collector/fstmatrix.conf
+
+dash_files=\
+	index.html \
+	all.html \
+	jquery.js \
+	fstests.css \
+	fstests.js \
+	x.big.png \
+	x.png \
+	.htaccess
+
+wwwfiles=\
+	collector/uploader.php \
+	$(patsubst %,dashboard/%,$(dash_files))
+
+reporter_cfg=reporter/config
+configfiles=$(reporter_cfg)
+
+built_files=\
+	collector/fstmatrix-receive.service \
+	collector/fstmatrix-receive.socket \
+	collector/fstmatrix-stow.service \
+	collector/receive_tarball \
+	collector/uploader.php \
+	dashboard/dashboard.conf \
+	dashboard/stow_dashboard \
+	database/create_db \
+	database/create_views \
+	database/db \
+	database/query_machines \
+	database/query_all_test_runs \
+	database/query_recent_test_runs \
+	database/query_test_run \
+	database/upsert_test_run \
+	reporter/collect-results \
+	reporter/copy-failure-info \
+	reporter/fstests-reporter \
+	reporter/fstmatrix-reporter.service \
+	dashboard/fstmatrix-dashboard.service \
+	reporter/upload-all-results \
+	dashboard/create_dashboard \
+	database/archive \
+	dashboard/fstests.css \
+	dashboard/config-fstests-dashboard \
+	collector/fstmatrix.conf \
+	collector/create_collector \
+	collector/create-fstests-collector \
+	collector/fstmatrix.conf
+
+all: $(libprogs) $(libfiles) $(progs) $(service_files) $(wwwfiles) $(configfiles) $(sbinprogs) $(sysusers_files)
+
+clean:;
+	rm -f $(built_files)
+
+database/query_recent_test_runs: database/query_all_test_runs
+	ln -s -f query_all_test_runs $@
+
+dashboard/jquery.js:
+	wget https://code.jquery.com/jquery-4.0.0.js -O $@
+
+install: all
+	install -d $(DESTDIR)$(pkg_share_dir)
+	install -m 0644 $(wwwfiles) $(DESTDIR)$(pkg_share_dir)
+	install -d $(DESTDIR)$(pkg_lib_dir)
+	install -m 0644 $(libfiles) $(DESTDIR)$(pkg_lib_dir)
+	install -d $(DESTDIR)$(pkg_libexec_dir)
+	install -m 0755 $(libprogs) $(DESTDIR)$(pkg_libexec_dir)
+	ln -s -f query_all_test_runs $(DESTDIR)$(pkg_libexec_dir)/query_recent_test_runs
+	install -d $(DESTDIR)$(systemd_service_dir)
+	install -m 0644 $(service_files) $(DESTDIR)$(systemd_service_dir)
+	install -d $(DESTDIR)$(bin_dir)
+	install -m 0755 $(progs) $(DESTDIR)$(bin_dir)
+	install -d $(DESTDIR)$(sbin_dir)
+	install -m 0755 $(sbinprogs) $(DESTDIR)$(sbin_dir)
+	install -d $(DESTDIR)$(man1_dir)
+	install -m 0644 $(man1pages) $(DESTDIR)$(man1_dir)
+	install -d $(DESTDIR)$(man8_dir)
+	install -m 0644 $(man8pages) $(DESTDIR)$(man8_dir)
+	install -d $(DESTDIR)$(etc_dir)
+	install -m 0644 $(reporter_cfg) $(DESTDIR)$(etc_dir)/fstmatrix-reporter
+	install -d $(DESTDIR)$(systemd_sysusers_dir)
+	install -m 0644 $(sysusers_files) $(DESTDIR)$(systemd_sysusers_dir)/
diff --git a/matrix/README b/matrix/README
new file mode 100644
index 00000000000000..a619da0606c96e
--- /dev/null
+++ b/matrix/README
@@ -0,0 +1,11 @@
+To create database:
+
+./create_db <database dir>
+
+To add results to database:
+
+./stow_tarballs <database dir> <xfsout tarball dir>
+
+To force reprocessing:
+
+rm <xfsout tarball dir>/tarballs.list

