Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3296D267729
	for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 17:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739554616; cv=none; b=N+niiUK5YpZRh+uTUkQReRSQC3YbpmrG2Akk8d9U2WhjSmFzoMhokPfDZ34szMM+x9qVRHMCaJmw7wCGP9caLEPyIsnJe/QsgtcpQH7T9jL0niRk9HD4meoh/dI+OcMztLm9Cmpsi5Sb1S//kXaW8jEZvpxzWiXnx6twPjc2Bus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739554616; c=relaxed/simple;
	bh=syROS8E/t3iWuXdsUXFyTdmLOT/8cMJ0ac68cAafKCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kFFEDIdb1mcu2d9eNmVQAEsG62Fmzy22B/ssVQfiv3Bno0Z1euLpLKcPwzZu64lQlzKGMFojpB3s5pSJx00UfO54HRfvIIeZVz6S0LSHSI4zNWbA1NC5cmfBG5VdsbUgnEy74JAWJB8jzSSDhOWYHX5P0GcJdkqMmACMjMmGUEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C8Za6+JM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C8Za6+JM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1739554613;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mIYW89rj1jgKVdeQ/6ueXRZ8vK6r0DC3/YTZY3TVqCM=;
	b=C8Za6+JMPaOr4sOiJACpM13JgpWSgAqjCAguD1deyiOZlFywmwo/n/Fy29FvYZmD/d5kwy
	P199gNyRoFTwhkghFEuDt/AjJgT8zmn7AbQLWPEuuskI7dHMBahkM6eCScIKg9BjEXuaeF
	nwOR2kd+9SVSEvSvNsXG2QLaecdi/CY=
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com
 [209.85.216.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-ocuTLTOhM72aQXUicw9veQ-1; Fri, 14 Feb 2025 12:36:51 -0500
X-MC-Unique: ocuTLTOhM72aQXUicw9veQ-1
X-Mimecast-MFC-AGG-ID: ocuTLTOhM72aQXUicw9veQ_1739554606
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-2fc17c3eeb5so4002157a91.1
        for <linux-xfs@vger.kernel.org>; Fri, 14 Feb 2025 09:36:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739554606; x=1740159406;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mIYW89rj1jgKVdeQ/6ueXRZ8vK6r0DC3/YTZY3TVqCM=;
        b=byvxmO+CwWtgJFtzgJBNbIDnZgXybrtkJcpVch8cy2Y7GP1j7qjmeXAQb2P+hoj61y
         38S/L4gdptDJ6eYm1oD7ezNnwclaOYLm5PpeAbutxFIBrXzbb2hT/eL7ajLiluWC3gfu
         0mmDZkv/rYRvu+g/adZRMbu9ZpDkEd0oQVN0cUaZmt9XF9LRKCZYNoZnJwtC5rnOL63x
         Les2R2WdXO3OJCXTwo5yoVE0QnqioNeH4vtEAMwHoXVZ6siQFnj+SNpiBzLX7nVKDAdR
         /yr9KFtnU2+rxj0KscdDRMwsJfx4smgmq74BK0ijONjO8JPZ5f5LOAVmsTgnP12InGss
         SU1w==
X-Forwarded-Encrypted: i=1; AJvYcCVU2f12EDdazuGXBY+gRSzC1HlCmLBSNEl7dMoIw1HoHEd12kJ2JYSQtjTsVpHfQoI7jSdyi5v5l/M=@vger.kernel.org
X-Gm-Message-State: AOJu0YzEH2AYZWPU5pZsh/nMQCsN43LHnLPArk56wRLHkXGDWVWKDNFu
	7vCuoZCVD5JGr+uDPdA3Ei/fGmxScPQSUUS3Rpy8S9B2qoEGKAtR0SPwQfYe9MKlkktwQVhJB4d
	uiaP2TROZgOM3liXZODjoLvjnhsh4YGRwoTSwE2N0KGjmvHdSDRcXTRvF2snKPK/bdOCm
X-Gm-Gg: ASbGnct4fh1Zpukj1K2yvIZIJOl6MQUN2vpLl9689qR1fxZ8OReCPnTBTSkaVdfkaec
	AQEQJ3mHqotygkmQBYQDjXPKT2Nh5iZjD+Feq8fdjnejakk0AJjNgx5J392nGrJZNXjNzz3OYpY
	4WAlb5Zw35+U+CXd0JipH88aWTKEorbOBd/1NROeW39JoJk6Wvr/SH8HVI1LHzB0Z05EtZFVW8p
	lyAnbxGHVlvDWCpZN9FZkFfuM7ox4Itb0dVKKjiE6O9osaLfJALlgiCElymgxnli8LgrBY3Koev
	hoy6iR3ZtGb6SaZo9Ps6aLPy4nnvFP5sigkSYoufc8u16Q==
X-Received: by 2002:a05:6a00:1882:b0:730:957d:a80f with SMTP id d2e1a72fcca58-7326177625dmr333864b3a.2.1739554605790;
        Fri, 14 Feb 2025 09:36:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGnXU5meeNYW4WcXw758/zfG75iYWsXQ2srW6MQ4yIRRVnHA/DXUK9Y/Urg/0yFwuwloJYNXQ==
X-Received: by 2002:a05:6a00:1882:b0:730:957d:a80f with SMTP id d2e1a72fcca58-7326177625dmr333801b3a.2.1739554605170;
        Fri, 14 Feb 2025 09:36:45 -0800 (PST)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7324273e3e7sm3491092b3a.91.2025.02.14.09.36.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2025 09:36:44 -0800 (PST)
Date: Sat, 15 Feb 2025 01:36:41 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: dchinner@redhat.com, fstests@vger.kernel.org, linux-xfs@vger.kernel.org
Subject: Re: [PATCH 15/34] check: run tests in a private pid/mount namespace
Message-ID: <20250214173641.6ozk7xk7gq2cp6sy@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <173933094308.1758477.194807226568567866.stgit@frogsfrogsfrogs>
 <173933094584.1758477.17381421804809266222.stgit@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <173933094584.1758477.17381421804809266222.stgit@frogsfrogsfrogs>

On Tue, Feb 11, 2025 at 07:34:35PM -0800, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> As mentioned in the previous patch, trying to isolate processes from
> separate test instances through the use of distinct Unix process
> sessions is annoying due to the many complications with signal handling.
> 
> Instead, we could just use nsexec to run the test program with a private
> pid namespace so that each test instance can only see its own processes;
> and private mount namespace so that tests writing to /tmp cannot clobber
> other tests or the stuff running on the main system.  Further, the
> process created by the clone(CLONE_NEWPID) call is considered the init
> process of that pid namespace, so all processes will be SIGKILL'd when
> the init process terminates, so we no longer need systemd scopes for
> externally enforced cleanup.
> 
> However, it's not guaranteed that a particular kernel has pid and mount
> namespaces enabled.  Mount (2.4.19) and pid (2.6.24) namespaces have
> been around for a long time, but there's no hard requirement for the
> latter to be enabled in the kernel.  Therefore, this bugfix slips
> namespace support in alongside the session id thing.
> 
> Declaring CONFIG_PID_NS=n a deprecated configuration and removing
> support should be a separate conversation, not something that I have to
> do in a bug fix to get mainline QA back up.
> 
> Note that the new helper cannot unmount the /proc it inherits before
> mounting a pidns-specific /proc because generic/504 relies on being able
> to read the init_pid_ns (aka systemwide) version of /proc/locks to find
> a file lock that was taken and leaked by a process.
> 
> Cc: <fstests@vger.kernel.org> # v2024.12.08
> Fixes: 8973af00ec212f ("fstests: cleanup fsstress process management")
> Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
> Reviewed-by: Dave Chinner <dchinner@redhat.com>
> ---
>  check               |   34 +++++++++++++++++++++++-----------
>  common/rc           |   12 ++++++++++--
>  src/nsexec.c        |   18 +++++++++++++++---
>  tests/generic/504   |   15 +++++++++++++--
>  tools/run_privatens |   28 ++++++++++++++++++++++++++++

As I said in [PATCH 14/34], this patch has the same problem due to the
tools/run_privatens won't be copied to /var/lib/xfstests.


>  5 files changed, 89 insertions(+), 18 deletions(-)
>  create mode 100755 tools/run_privatens
> 
> 
> diff --git a/check b/check
> index fb9b514e5cb1eb..8834c96772bde8 100755
> --- a/check
> +++ b/check
> @@ -674,6 +674,11 @@ _stash_test_status() {
>  	esac
>  }
>  
> +# Can we run in a private pid/mount namespace?
> +HAVE_PRIVATENS=
> +./tools/run_privatens bash -c "exit 77"
> +test $? -eq 77 && HAVE_PRIVATENS=yes
> +
>  # Can we run systemd scopes?
>  HAVE_SYSTEMD_SCOPES=
>  systemctl reset-failed "fstests-check" &>/dev/null
> @@ -691,22 +696,29 @@ _adjust_oom_score -500
>  # the system runs out of memory it'll be the test that gets killed and not the
>  # test framework.  The test is run in a separate process without any of our
>  # functions, so we open-code adjusting the OOM score.
> -#
> -# If systemd is available, run the entire test script in a scope so that we can
> -# kill all subprocesses of the test if it fails to clean up after itself.  This
> -# is essential for ensuring that the post-test unmount succeeds.  Note that
> -# systemd doesn't automatically remove transient scopes that fail to terminate
> -# when systemd tells them to terminate (e.g. programs stuck in D state when
> -# systemd sends SIGKILL), so we use reset-failed to tear down the scope.
> -#
> -# Use setsid to run the test program with a separate session id so that we
> -# can pkill only the processes started by this test.
>  _run_seq() {
>  	local res
>  	unset CHILDPID
>  	unset FSTESTS_ISOL	# set by tools/run_seq_*
>  
> -	if [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
> +	if [ -n "${HAVE_PRIVATENS}" ]; then
> +		# If pid and mount namespaces are available, run the whole test
> +		# inside them so that the test cannot access any process or
> +		# /tmp contents that it does not itself create.  The ./$seq
> +		# process is considered the "init" process of the pid
> +		# namespace, so all subprocesses will be sent SIGKILL when it
> +		# terminates.
> +		./tools/run_privatens "./$seq"
> +		res=$?
> +	elif [ -n "${HAVE_SYSTEMD_SCOPES}" ]; then
> +		# If systemd is available, run the entire test script in a
> +		# scope so that we can kill all subprocesses of the test if it
> +		# fails to clean up after itself.  This is essential for
> +		# ensuring that the post-test unmount succeeds.  Note that
> +		# systemd doesn't automatically remove transient scopes that
> +		# fail to terminate when systemd tells them to terminate (e.g.
> +		# programs stuck in D state when systemd sends SIGKILL), so we
> +		# use reset-failed to tear down the scope.
>  		local unit="$(systemd-escape "fs$seq").scope"
>  		systemctl reset-failed "${unit}" &> /dev/null
>  		systemd-run --quiet --unit "${unit}" --scope \
> diff --git a/common/rc b/common/rc
> index 3f981900e89081..8d42396777c950 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -33,7 +33,11 @@ _test_sync()
>  # Kill only the processes started by this test.
>  _pkill()
>  {
> -	pkill --session 0 "$@"
> +	if [ "$FSTESTS_ISOL" = "setsid" ]; then
> +		pkill --session 0 "$@"
> +	else
> +		pkill "$@"
> +	fi
>  }
>  
>  # Common execution handling for fsstress invocation.
> @@ -2736,7 +2740,11 @@ _require_user_exists()
>  # not, passing $SHELL in this manner works both for "su" and "su -c cmd".
>  _su()
>  {
> -	su --session-command $SHELL "$@"
> +	if [ "$FSTESTS_ISOL" = "setsid" ]; then
> +		su --session-command $SHELL "$@"
> +	else
> +		su "$@"
> +	fi
>  }
>  
>  # check if a user exists and is able to execute commands.
> diff --git a/src/nsexec.c b/src/nsexec.c
> index 750d52df129716..5c0bc922153514 100644
> --- a/src/nsexec.c
> +++ b/src/nsexec.c
> @@ -54,6 +54,7 @@ usage(char *pname)
>      fpe("            If -M or -G is specified, -U is required\n");
>      fpe("-s          Set uid/gid to 0 in the new user namespace\n");
>      fpe("-v          Display verbose messages\n");
> +    fpe("-z          Return child's return value\n");
>      fpe("\n");
>      fpe("Map strings for -M and -G consist of records of the form:\n");
>      fpe("\n");
> @@ -144,6 +145,8 @@ int
>  main(int argc, char *argv[])
>  {
>      int flags, opt;
> +    int return_child_status = 0;
> +    int child_status = 0;
>      pid_t child_pid;
>      struct child_args args;
>      char *uid_map, *gid_map;
> @@ -161,7 +164,7 @@ main(int argc, char *argv[])
>      setid = 0;
>      gid_map = NULL;
>      uid_map = NULL;
> -    while ((opt = getopt(argc, argv, "+imnpuUM:G:vs")) != -1) {
> +    while ((opt = getopt(argc, argv, "+imnpuUM:G:vsz")) != -1) {
>          switch (opt) {
>          case 'i': flags |= CLONE_NEWIPC;        break;
>          case 'm': flags |= CLONE_NEWNS;         break;
> @@ -173,6 +176,7 @@ main(int argc, char *argv[])
>          case 'G': gid_map = optarg;             break;
>          case 'U': flags |= CLONE_NEWUSER;       break;
>          case 's': setid = 1;                    break;
> +        case 'z': return_child_status = 1;      break;
>          default:  usage(argv[0]);
>          }
>      }
> @@ -229,11 +233,19 @@ main(int argc, char *argv[])
>  
>      close(args.pipe_fd[1]);
>  
> -    if (waitpid(child_pid, NULL, 0) == -1)      /* Wait for child */
> +    if (waitpid(child_pid, &child_status, 0) == -1)      /* Wait for child */
>          errExit("waitpid");
>  
>      if (verbose)
> -        printf("%s: terminating\n", argv[0]);
> +        printf("%s: terminating %d\n", argv[0], WEXITSTATUS(child_status));
> +
> +    if (return_child_status) {
> +        if (WIFEXITED(child_status))
> +            exit(WEXITSTATUS(child_status));
> +        if (WIFSIGNALED(child_status))
> +            exit(WTERMSIG(child_status) + 128); /* like sh */
> +	exit(EXIT_FAILURE);
> +    }
>  
>      exit(EXIT_SUCCESS);
>  }
> diff --git a/tests/generic/504 b/tests/generic/504
> index 271c040e7b842a..611e6c283e215a 100755
> --- a/tests/generic/504
> +++ b/tests/generic/504
> @@ -18,7 +18,7 @@ _cleanup()
>  {
>  	exec {test_fd}<&-
>  	cd /
> -	rm -f $tmp.*
> +	rm -r -f $tmp.*
>  }
>  
>  # Import common functions.
> @@ -35,13 +35,24 @@ echo inode $tf_inode >> $seqres.full
>  
>  # Create new fd by exec
>  exec {test_fd}> $testfile
> -# flock locks the fd then exits, we should see the lock info even the owner is dead
> +# flock locks the fd then exits, we should see the lock info even though the
> +# owner is dead.  If we're using pid namespace isolation we have to move /proc
> +# so that we can access the /proc/locks from the init_pid_ns.
> +if [ "$FSTESTS_ISOL" = "privatens" ]; then
> +	move_proc="$tmp.procdir"
> +	mkdir -p "$move_proc"
> +	mount --move /proc "$move_proc"
> +fi
>  flock -x $test_fd
>  cat /proc/locks >> $seqres.full
>  
>  # Checking
>  grep -q ":$tf_inode " /proc/locks || echo "lock info not found"
>  
> +if [ -n "$move_proc" ]; then
> +	mount --move "$move_proc" /proc
> +fi
> +
>  # success, all done
>  status=0
>  echo "Silence is golden"
> diff --git a/tools/run_privatens b/tools/run_privatens
> new file mode 100755
> index 00000000000000..df94974ab30c3c
> --- /dev/null
> +++ b/tools/run_privatens
> @@ -0,0 +1,28 @@
> +#!/bin/bash
> +
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2025 Oracle.  All Rights Reserved.
> +#
> +# Try starting things in a private pid/mount namespace with a private /tmp
> +# and /proc so that child process trees cannot interfere with each other.
> +
> +if [ -n "${FSTESTS_ISOL}" ]; then
> +	for path in /proc /tmp; do
> +		mount --make-private "$path"
> +	done
> +	mount -t proc proc /proc
> +	mount -t tmpfs tmpfs /tmp
> +
> +	# Allow the test to become a target of the oom killer
> +	oom_knob="/proc/self/oom_score_adj"
> +	test -w "${oom_knob}" && echo 250 > "${oom_knob}"
> +
> +	exec "$@"
> +fi
> +
> +if [ -z "$1" ] || [ "$1" = "--help" ]; then
> +	echo "Usage: $0 command [args...]"
> +	exit 1
> +fi
> +
> +FSTESTS_ISOL=privatens exec "$(dirname "$0")/../src/nsexec" -z -m -p "$0" "$@"
> 

