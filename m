Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795642138;
	b=KXuTZVOnQRQASf++fZBmB3l6KKArXMG0sei62fkCqH97JmhgXM+gaWdqqYXkHPE5b4O4
	 suY+svB4DucLW9ugVpFCjx64zNQ0ziC1TbDaF8KgkUM1v94dRljbYZDGjhLgoTwekIgmz
	 j841L5dT3zZXgiW1oxVLKQ6DQIhtIBc7ITwVdrm9cPLBdv2/O/oAs2Uo8nZVLVGlb9Jaw
	 X1IlZreVf5pAmONiTvgFPxHv8il9aLPBTtAeAVg4YzN/Q9cHGePACnTmVbcs5Gx3Z6NNF
	 z2UmgA+irHsib6LSrFe3E880Krf5cVwmJv3ilGeiycJl0ORwF08M1jKCIp1oje6fW5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795642138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=28BuPQQ4mw5Zm0fhQO8nOpkI5A+60ixyODEHYhwVeCE=;
	b=uvQ4T89YGVhFJoO5bkHMXpfILfFGPR4PpwZN7Gg2bH71IxLLb2YluHywdmaXZIMSKUA4
	 +lCRVkDUckUopRcNtaWzEKx7ncaP8kSctdCqMBdPYZA39mqQ2GdIFBf7nMNd3cjEHpdHq
	 8gy0yYhbr5yoLSoSXVGATUQI/IMMIFm7XcHFYdlSTM4bUMvwZAe/KE3UUYKewuFtDBEt1
	 bCmANh0IxcC1t3HDP6SDWqXlZPfx/cScnvsoAdOCEn1MeDpp8FIN6ZaP+OfQp774jnZzr
	 OvOUk5J7BifUK1xNlCbfsoDp++O/tpiL/CIqg/O7FrehtN8dv6qwLj0jTchxLkmnYXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="GAON0J/Y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB67D60A2607;
	Wed, 25 Nov 2026 21:28:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GAON0J/Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4286D1F000E1;
	Wed, 25 Nov 2026 21:28:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642137;
	bh=28BuPQQ4mw5Zm0fhQO8nOpkI5A+60ixyODEHYhwVeCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GAON0J/YGPvVSaAZaskF1naYTzSwW/fG+qr7FL30zz1kYsTEaG4tcSF+hPCzUonyk
	 9KGPckqjLnOnUyhDMWj55z3edpBsH7JRHI3k/Q6rtcOfgdrCxJxHIMDboDMepeQRHU
	 IHjRhUWyAxwreSmwklwxo+JeH7DWE3k7XBSgWAT+QCysQUfsuN/CIeOnMuFhPE/5x/
	 ANfUeiE/Xl9HGpR1EnX8tRvhTLItLSfaO/jrhP2qP80owX12vfzfrFr2nP09Jwb3gF
	 U2uC4lgnEg3qna+L8qdk1pD5NEgfNCl5e4QsX/GCLMh3vD+rv3LAqPVowkzAXICGFL
	 dS5mpk9E2wbRg==
From: Zorro Lang <zlang@kernel.org>
To: fstests@vger.kernel.org
Cc: Andrey Albershteyn <aalbersh@redhat.com>,
	cem@kernel.org,
	Dave Chinner <david@fromorbit.com>,
	linux-xfs@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-ext4@vger.kernel.org
Subject: [PATCH 6/6] doc: document the test hooks
Date: Thu, 26 Nov 2026 05:28:23 +0800
Message-ID: <20261125212823.3389430-7-zlang@kernel.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261125212823.3389430-1-zlang@kernel.org>
References: <20261125212823.3389430-1-zlang@kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Post: <mailto:linux-xfs@vger.kernel.org>
List-Help: <mailto:linux-xfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-xfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add README.hooks describing the hook events, modes, the context hooks
receive and the limitations, with examples for both modes.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 README.hooks | 156 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 156 insertions(+)
 create mode 100644 README.hooks

diff --git a/README.hooks b/README.hooks
new file mode 100644
index 00000000..66cd4ddd
--- /dev/null
+++ b/README.hooks
@@ -0,0 +1,156 @@
+Hooks
+=====
+
+Test hooks let you customize a test run without modifying fstests.  Each
+hook is a script or executable that 'check' runs at specific points during
+a test.  Register hooks with the --hook-pre-test, --hook-post-test, and
+--hook-post-result options:
+
+        --hook-pre-test path=/path/to/script[,mode=in|out][,match=<glob>]...
+
+Each option can be repeated; hooks run in the order given.  Without a
+match pattern, a hook runs for every test; otherwise, it runs only when
+the test name (e.g. generic/482) matches at least one of the glob patterns.
+Match patterns cannot contain whitespace or commas.
+
+Note: Relative paths are resolved from the fstests root directory ($here).
+      Tilde (~) expansion is not supported; use $HOME or an absolute path.
+
+
+Events
+------
+
+pre-test
+        Runs right before each test starts (once per iteration when using
+        -i or -L).
+
+post-test
+        Runs right after each test finishes, before golden output
+        comparison, passing the test's exit code.
+
+post-result
+        Runs once each test's final result (pass/fail/notrun/expunge) is
+        determined, passing the result and runtime.  It runs even when no
+        report format (-R) is requested.
+
+
+Modes
+-----
+
+mode=in (default)
+        The script is sourced in a subshell and has full access to the
+        test environment (devices, mount points, options, and fstests
+        helpers).  It should define hook_execute(); scripts without it
+        are silently skipped.
+
+mode=out
+        The hook runs as a standalone executable (written in any
+        language).  It has no access to the test shell environment or
+        fstests helpers; instead, 'check' passes the hook context via
+        arguments and environment variables.  Requires env(1), and the
+        hook file must be executable.
+
+
+Hook context
+------------
+
+Both modes run hooks with the same basic context:
+
+        $1              test name (e.g. generic/482)
+        $2              status: test exit code (post-test), final result
+                        such as pass/fail/notrun/expunge (post-result),
+                        or invalid (pre-test)
+        HOOK_EVENT      the event name (pre-test, post-test, post-result)
+        runtime         test runtime in seconds (post-result only; invalid
+                        for pre-test and post-test)
+        cwd             $here (the fstests root directory)
+        stdin           /dev/null
+        stdout/stderr   appended to $seqres.hooks
+
+In addition, mode=out hooks receive the following 'check' variables in
+their environment (mode=in hooks already inherit them).  Unconfigured
+variables may be empty:
+
+        FSTYP section iters
+        TEST_DEV TEST_DIR SCRATCH_DEV SCRATCH_MNT
+        MKFS_OPTIONS MOUNT_OPTIONS
+        RESULT_BASE REPORT_DIR seqres seqnum
+
+Hook failures are logged to $seqres.hooks and never affect the test result.
+
+
+Examples
+--------
+
+Trace a single test across multiple iterations with trace-cmd (mode=in):
+
+        $ mkdir -p $HOME/wrapper
+        $ cat > $HOME/wrapper/trace-start <<'EOF'
+        hook_execute()
+        {
+                trace-cmd start -b 8192 -e xfs\* -e xlog\*
+        }
+        EOF
+
+        $ cd /path/to/xfstests/
+        $ mkdir -p hooks
+        $ cat > hooks/trace-stop <<'EOF'
+        hook_execute()
+        {
+                trace-cmd extract -o $seqres.trace.dat
+                trace-cmd reset
+                trace-cmd report -i $seqres.trace.dat > $seqres.trace
+        }
+        EOF
+
+        $ ./check --hook-pre-test path=$HOME/wrapper/trace-start,match=generic/482 \
+                  --hook-post-test path=hooks/trace-stop,match=generic/482 \
+                  -i 100 generic/482
+
+Report each test result to an external framework (mode=out):
+
+        $ mkdir -p /opt/fstests-hooks
+        $ cat > /opt/fstests-hooks/report.sh <<'EOF'
+        #!/bin/bash
+        case "$2" in
+        pass)    outcome=pass ;;
+        fail)    outcome=fail ;;
+        notrun)  outcome=skip ;;
+        *)       outcome=error ;;
+        esac
+        my-reporter --name "/$section/$1" --result "$outcome" --runtime "$runtime"
+        EOF
+        $ chmod +x /opt/fstests-hooks/report.sh
+        $ ./check --hook-post-result path=/opt/fstests-hooks/report.sh,mode=out \
+                  -g quick
+
+Keep a hook inside the fstests tree and use a relative path (resolved
+from the fstests root directory):
+
+        $ cd /path/to/xfstests/
+        $ mkdir -p hooks
+        $ cat > myhooks/pre-greet.sh <<'EOF'
+        hook_execute()
+        {
+                echo "running $1"
+        }
+        EOF
+        $ chmod +x hooks/pre-greet.sh
+        $ ./check --hook-pre-test path=hooks/pre-greet.sh generic/001
+
+Run a pair of out-of-process hooks on every xfs test with a glob match,
+repeating the same option (hooks run in the order given):
+
+        $ cd /path/to/xfstests/
+        $ cat > hooks1/notify.sh <<'EOF'
+        #!/bin/bash
+        echo "$1 finished with status $2" | logger -t fstests
+        EOF
+        $ cat > hooks2/save-log.sh <<'EOF'
+        #!/bin/bash
+        cp "$seqres.full" /var/log/fstests/"$seqnum".full
+        EOF
+        $ chmod +x hooks1/notify.sh hooks2/save-log.sh
+        $ ./check --hook-post-test path=hooks1/notify.sh,mode=out,match=xfs/0* \
+                  --hook-post-test path=hooks2/save-log.sh,mode=out \
+                  -g auto
-- 
2.56.0

