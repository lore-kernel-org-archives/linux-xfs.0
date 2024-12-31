Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAA31B0425
	for <linux-xfs@vger.kernel.org>; Tue, 31 Dec 2024 23:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735689050; cv=none; b=NIACKYFsLCRcN3mGA/66xRq85OAjuL7YDvWT0+ZGutkJH49QA4pkjKbzfLcys5GkbMCYwxKd1qGKGXAjBTcjI1jIiqvLyScVqAnl5Zk3z/4HSm80u3gyOvFxai/uI+obm47PlpC3LN6NScMQhSfbJYuNHuoB+41ZTS8VOzYlbJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735689050; c=relaxed/simple;
	bh=sf4DJSSibXS1HhhtSfuW0MSPPb5Kxi3HVM8lCpIBEN4=;
	h=Date:Subject:From:To:Cc:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GIX3F8wnLtMMDNF0audA631/lPCTJwrVKcx88YWP59h95CFDSaQRw1iNGpq/ZJp4X6s2XXIM1sOv4gI6Xq0oB7tg7BslIwLS/xMwOGpLUHc+BdTAmfIt+kcVP0Pn6vErC+3nUWGla5QdQsQb3bMhs4JB86eh57FsfR25zUBLXNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HjfpMWht; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HjfpMWht"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D01C4CED2;
	Tue, 31 Dec 2024 23:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1735689050;
	bh=sf4DJSSibXS1HhhtSfuW0MSPPb5Kxi3HVM8lCpIBEN4=;
	h=Date:Subject:From:To:Cc:In-Reply-To:References:From;
	b=HjfpMWht0AOMCY3BxRtG4iCEHfS7ctxMj/JKbwcdZDc62/MVdrU8LvR7/+jcSCQuf
	 ELkBLfgsa2xTKeInamqlsc819CANmX2EvbEseFgQOGqDT0rQU0ccNZ296yOGOv/oqa
	 Pkjpe2TtKegxUgbxsGFQvzKxow+0Ys2F+xiIN8nGqreQyviuUqggEk5/fzlaXhwPnz
	 XwED+u+8QYknbPKPEx//aF2WpbA82KN1uiR8CRlSWICUXcxK5LjHtYgkAhkWoUTXrv
	 a5l6Kc84m9wDTahZ4AcYlsFNS6Pg464GvdqMRxRbcoZCoj/Pxhhs0l47UwIhcfF9ne
	 fvRUcsvgoCUPQ==
Date: Tue, 31 Dec 2024 15:50:50 -0800
Subject: [PATCH 12/21] xfs_scrubbed: check events against schema
From: "Darrick J. Wong" <djwong@kernel.org>
To: aalbersh@kernel.org, djwong@kernel.org
Cc: linux-xfs@vger.kernel.org
Message-ID: <173568778645.2710211.11707695819627896340.stgit@frogsfrogsfrogs>
In-Reply-To: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
References: <173568778426.2710211.10173859713748230492.stgit@frogsfrogsfrogs>
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
 libxfs/Makefile       |   10 ++++++--
 scrub/Makefile        |    1 +
 scrub/xfs_scrubbed.in |   62 +++++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 70 insertions(+), 3 deletions(-)


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
diff --git a/scrub/Makefile b/scrub/Makefile
index bd910922ceb4bb..7d4fa0ddc09685 100644
--- a/scrub/Makefile
+++ b/scrub/Makefile
@@ -129,6 +129,7 @@ xfs_scrubbed: xfs_scrubbed.in $(builddefs)
 	$(Q)$(SED) -e "s|@sbindir@|$(PKG_SBIN_DIR)|g" \
 		   -e "s|@scrub_svcname@|$(scrub_svcname)|g" \
 		   -e "s|@pkg_version@|$(PKG_VERSION)|g" \
+		   -e "s|@pkg_data_dir@|$(PKG_DATA_DIR)|g" \
 		   < $< > $@
 	$(Q)chmod a+x $@
 
diff --git a/scrub/xfs_scrubbed.in b/scrub/xfs_scrubbed.in
index 4d742a9151a082..992797113d6d30 100644
--- a/scrub/xfs_scrubbed.in
+++ b/scrub/xfs_scrubbed.in
@@ -18,6 +18,52 @@ import ctypes
 import gc
 from concurrent.futures import ProcessPoolExecutor
 
+try:
+	# Not all systems will have this json schema validation libarary,
+	# so we make it optional.
+	import jsonschema
+
+	def init_validation(args):
+		'''Initialize event json validation.'''
+		try:
+			with open(args.event_schema) as fp:
+				schema_js = json.load(fp)
+		except Exception as e:
+			print(f"{args.event_schema}: {e}", file = sys.stderr)
+			return
+
+		try:
+			vcls = jsonschema.validators.validator_for(schema_js)
+			vcls.check_schema(schema_js)
+			validator = vcls(schema_js)
+		except jsonschema.exceptions.SchemaError as e:
+			print(f"{args.event_schema}: invalid event data, {e.message}",
+					file = sys.stderr)
+			return
+		except Exception as e:
+			print(f"{args.event_schema}: {e}", file = sys.stderr)
+			return
+
+		def v(i):
+			e = jsonschema.exceptions.best_match(validator.iter_errors(i))
+			if e:
+				print(f"{printf_prefix}: {e.message}",
+						file = sys.stderr)
+				return False
+			return True
+
+		return v
+
+except:
+	def init_validation(args):
+		if args.require_validation:
+			print("JSON schema validation not available.",
+					file = sys.stderr)
+			return
+
+		return lambda instance: True
+
+validator_fn = None
 debug = False
 log = False
 everything = False
@@ -177,6 +223,12 @@ def handle_event(event):
 
 	global log
 
+	# Ignore any event that doesn't pass our schema.  This program must
+	# not try to handle a newer kernel that say things that it is not
+	# prepared to handle.
+	if not validator_fn(event):
+		return
+
 	stringify_timestamp(event)
 	if log:
 		log_event(event)
@@ -225,6 +277,7 @@ def main():
 	global printf_prefix
 	global everything
 	global debug_fast
+	global validator_fn
 
 	parser = argparse.ArgumentParser( \
 			description = "XFS filesystem health monitoring demon.")
@@ -240,6 +293,11 @@ def main():
 			help = 'XFS filesystem mountpoint to target.')
 	parser.add_argument('--debug-fast', action = 'store_true', \
 			help = argparse.SUPPRESS)
+	parser.add_argument('--require-validation', action = 'store_true', \
+			help = argparse.SUPPRESS)
+	parser.add_argument('--event-schema', type = str, \
+			default = '@pkg_data_dir@/xfs_healthmon.schema.json', \
+			help = argparse.SUPPRESS)
 	args = parser.parse_args()
 
 	if args.V:
@@ -250,6 +308,10 @@ def main():
 		parser.error("the following arguments are required: mountpoint")
 		return 1
 
+	validator_fn = init_validation(args)
+	if not validator_fn:
+		return 1
+
 	if args.debug:
 		debug = True
 	if args.log:

