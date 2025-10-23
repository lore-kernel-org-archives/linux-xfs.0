Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DD78821
	for <linux-xfs@vger.kernel.org>; Thu, 23 Oct 2025 00:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761178137; cv=none; b=bjTsrWLTjPjpUQfyLW1iQ7C5JBCr4xF3+KoF+x+lB/bxW4BvlAWLbVW1rLwXol0Doqbm9o7OvX8N5g4NNBFJ4sBTfVfVtqyVxMVNLo9DQowi9poR6IQbcTDK+c882d5GJWLhdjW84qZei4Jl6u7WTBozXUpAzFUOolqfbbuwJ2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761178137; c=relaxed/simple;
	bh=NwSuP5HEe3U0PmUup/HSYC8gWBsDuGQ9j8qso7QQju8=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lFYz8wPsrlIr6aJl4TlFL4tDaSV5Z+Rvh4aAXITYEfDA3cD10TlAJzxcPIl+RWwo0nucPq+W3bWIK9pmYyI0Yxz8hDcRUrgJMB9ac0CpdeQaz2erIeYWVHr1FnrZoZS6ipSSvYbtxTnwLDcT0s3o9hndMDXW8WTKV4sUn8NaVK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Am/kRQzm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Am/kRQzm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CDBC4CEE7;
	Thu, 23 Oct 2025 00:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761178137;
	bh=NwSuP5HEe3U0PmUup/HSYC8gWBsDuGQ9j8qso7QQju8=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=Am/kRQzm7oBDh6KW+GQhykvU327o3YWopoJWH5k3/mSnXcwoI5J7CIU6oiwf8tomM
	 TSf4QvNtwGVLSoc6HKr9VHdpsLeq6T1fKGkV2eOe1s/e+QNIfWEwadICLdxsU+XbZI
	 ZrN/P3zubbKzHri036Ye0G9gbIjwf9mjxn3n95xpFJZhYs4gDOn0UNWWfM8Rct/ODH
	 nytQHaYA8wV1LaLZ6dPwwsTquQOlyp8VnianWLeOIbbaDmtq+vQ0SG/X5ErP4hBsfg
	 5/bhYWelECT9JFbFOh0QwTyH1S16liH+oC0kBcJRWTT1cgjSf7JUp3JyrZUO/wws9D
	 OtWNY7gyQcrFw==
Date: Wed, 22 Oct 2025 17:08:57 -0700
Subject: [PATCH 13/26] xfs_healer: check events against schema
From: "Darrick J. Wong" <djwong@kernel.org>
To: djwong@kernel.org, aalbersh@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <176117747712.1028044.13301065464967039197.stgit@frogsfrogsfrogs>
In-Reply-To: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
References: <176117747330.1028044.14577065342150898892.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit

From: Darrick J. Wong <djwong@kernel.org>

Validate that the event objects that we get from the kernel actually
obey the schema that the kernel publishes.

Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 healer/Makefile         |    1 +
 healer/xfs_healer.py.in |   62 +++++++++++++++++++++++++++++++++++++++++++++++
 libxfs/Makefile         |   10 +++++---
 3 files changed, 70 insertions(+), 3 deletions(-)


diff --git a/healer/Makefile b/healer/Makefile
index f0b3a62cd068b6..100e99cc9ef0a2 100644
--- a/healer/Makefile
+++ b/healer/Makefile
@@ -18,6 +18,7 @@ $(XFS_HEALER_PROG): $(XFS_HEALER_PROG).in $(builddefs) $(TOPDIR)/libfrog/gettext
 	$(Q)$(SED) -e "s|@pkg_version@|$(PKG_VERSION)|g" \
 		   -e '/@INIT_GETTEXT@/r $(TOPDIR)/libfrog/gettext.py' \
 		   -e '/@INIT_GETTEXT@/d' \
+		   -e "s|@pkg_data_dir@|$(PKG_DATA_DIR)|g" \
 		   < $< > $@
 	$(Q)chmod a+x $@
 
diff --git a/healer/xfs_healer.py.in b/healer/xfs_healer.py.in
index 507f537aea0d9a..459a07d3804ab5 100644
--- a/healer/xfs_healer.py.in
+++ b/healer/xfs_healer.py.in
@@ -20,6 +20,52 @@ import pathlib
 import gc
 from concurrent.futures import ProcessPoolExecutor
 
+try:
+	# Not all systems will have this json schema validation libarary,
+	# so we make it optional.
+	import jsonschema
+
+	def init_validation(args):
+		'''Initialize event json validation.'''
+		schema_file = args.event_schema
+		try:
+			with open(schema_file) as fp:
+				schema_js = json.load(fp)
+		except Exception as e:
+			eprintln(f"{schema_file}: {e}")
+			return
+
+		try:
+			vcls = jsonschema.validators.validator_for(schema_js)
+			vcls.check_schema(schema_js)
+			validator = vcls(schema_js)
+		except jsonschema.exceptions.SchemaError as e:
+			msg = _("invalid event data")
+			eprintln(f"{schema_file}: {msg}: {e.message}")
+			return
+		except Exception as e:
+			eprintln(f"{schema_file}: {e}")
+			return
+
+		def v(i):
+			e = jsonschema.exceptions.best_match(
+					validator.iter_errors(i))
+			if e:
+				eprintln(f"{printf_prefix}: {e.message}")
+				return False
+			return True
+
+		return v
+
+except:
+	def init_validation(args):
+		if args.require_validation:
+			eprintln(_("JSON schema validation not available."))
+			return
+
+		return lambda instance: True
+
+validator_fn = None
 debug = False
 log = False
 everything = False
@@ -229,6 +275,12 @@ def handle_event(lines):
 		eprintln(f"{printf_prefix}: {e} {fromm} {s}")
 		return
 
+	# Ignore any event that doesn't pass our schema.  This program must
+	# not try to handle a newer kernel that say things that it is not
+	# prepared to handle.
+	if not validator_fn(event):
+		return
+
 	# Deal with reporting-only events; these should always generate log
 	# messages.
 	if event['type'] == 'lost':
@@ -311,6 +363,7 @@ def main():
 	global printf_prefix
 	global everything
 	global debug_fast
+	global validator_fn
 
 	parser = argparse.ArgumentParser( \
 			description = _("Automatically heal damage to XFS filesystem metadata"))
@@ -326,6 +379,11 @@ def main():
 			help = _('XFS filesystem mountpoint to monitor'))
 	parser.add_argument('--debug-fast', action = 'store_true', \
 			help = argparse.SUPPRESS)
+	parser.add_argument('--require-validation', action = 'store_true', \
+			help = argparse.SUPPRESS)
+	parser.add_argument('--event-schema', type = str, \
+			default = '@pkg_data_dir@/xfs_healthmon.schema.json', \
+			help = argparse.SUPPRESS)
 	args = parser.parse_args()
 
 	if args.V:
@@ -338,6 +396,10 @@ def main():
 		parser.error(_("The following arguments are required: mountpoint"))
 		return 1
 
+	validator_fn = init_validation(args)
+	if not validator_fn:
+		return 1
+
 	if args.debug:
 		debug = True
 	if args.log:
diff --git a/libxfs/Makefile b/libxfs/Makefile
index 61c43529b532b6..f84eb5b43cdddd 100644
--- a/libxfs/Makefile
+++ b/libxfs/Makefile
@@ -151,6 +151,8 @@ EXTRA_OBJECTS=\
 
 LDIRT += $(EXTRA_OBJECTS)
 
+JSON_SCHEMAS=xfs_healthmon.schema.json
+
 #
 # Tracing flags:
 # -DMEM_DEBUG		all zone memory use
@@ -174,7 +176,7 @@ LTLIBS = $(LIBPTHREAD) $(LIBRT)
 # don't try linking xfs_repair with a debug libxfs.
 DEBUG = -DNDEBUG
 
-default: ltdepend $(LTLIBRARY) $(EXTRA_OBJECTS)
+default: ltdepend $(LTLIBRARY) $(EXTRA_OBJECTS) $(JSON_SCHEMAS)
 
 %dummy.o: %dummy.cpp
 	@echo "    [CXXD]   $@"
@@ -196,14 +198,16 @@ MAKECXXDEP := $(MAKEDEPEND) $(CXXFLAGS)
 include $(BUILDRULES)
 
 install: default
-	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
+	$(INSTALL) -m 755 -d $(PKG_DATA_DIR)
+	$(INSTALL) -m 644 $(JSON_SCHEMAS) $(PKG_DATA_DIR)
 
 install-headers: $(addsuffix -hdrs, $(PKGHFILES))
 
 %-hdrs:
 	$(Q)$(LN_S) -f $(CURDIR)/$* $(TOPDIR)/include/xfs/$*
 
-install-dev: install
+install-dev: default
+	$(INSTALL) -m 755 -d $(PKG_INC_DIR)
 	$(INSTALL) -m 644 $(PKGHFILES) $(PKG_INC_DIR)
 
 # We need to install the headers before building the dependencies.  If we

