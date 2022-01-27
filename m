Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3B98AC433F5
	for <linux-xfs@archiver.kernel.org>; Thu, 27 Jan 2022 02:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiA0Cwu (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Wed, 26 Jan 2022 21:52:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:22259 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229584AbiA0Cwu (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Wed, 26 Jan 2022 21:52:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1643251969;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kWKz7dCJ5Ew8+0klR8LjBnAFJfzmPJdpEk21qPjuCVI=;
        b=PTb4gDx9g28iCz68ZRFGdNE8SgB3wpOgw3z5ViqlnfeENP+Aou0wOeABqD1wrOFC6C8ueo
        rfVBGfuhfnSQL48lVtc7Od5jSGwFIPMzsiGwkIVO2AIp39wkXdHIFNuP0J4M3Dy5AdTUUC
        l7bUGn9H/44xeXrpLTqoRc0hK4Nq59o=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-596-YwjZcpVzNuOC7fKWxJo5Zw-1; Wed, 26 Jan 2022 21:52:48 -0500
X-MC-Unique: YwjZcpVzNuOC7fKWxJo5Zw-1
Received: by mail-pf1-f200.google.com with SMTP id d9-20020a62f809000000b004bb5ffee9b3so846933pfh.15
        for <linux-xfs@vger.kernel.org>; Wed, 26 Jan 2022 18:52:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=kWKz7dCJ5Ew8+0klR8LjBnAFJfzmPJdpEk21qPjuCVI=;
        b=Q3Qw2z5oeEPibCBrsWwXhT9sWpC3CYV5kqsDDQzAjo/+zZ5/N+lNp71mYT5INCRRRq
         NljJ1iks0zi3svX8tYUanrY6Uk/drJ8wEMsfENw8HrUE7naKl/lmSus86JBScDcaYrk6
         Bz/njwDDDmzPleHDZuS09KLPNPEVdGq/DgznG/fYExYH/0+XdxEYUTNMqxlseVqs92T7
         gHoRAN13llw53LG2M7yLhuDxNmiJJMSwru4xuhQeAy2E1rc/0QGIEOtIDMyQkRI/C5IF
         auKrqS+I1tOC3Lhq2u/gYPaByNxWca8RESxpTDblJqaISZV3lEJeB+RNhXXJZUPVQGq6
         UibA==
X-Gm-Message-State: AOAM531LabZq+rXFCFREhaNdGLn6RpClKcGcxTPLqw6NPtaaSGAS2K3t
        iiQDKadYCJu5W/PuHKVizA8JjA1nsI+JZ2qyRYNf4c+iQGRwMSvbp1JKE9Yq6LY31tGYgRcFtlF
        +BrHQcS2w3PY95TlHwDOD
X-Received: by 2002:a17:90b:4b8e:: with SMTP id lr14mr82875pjb.54.1643251966891;
        Wed, 26 Jan 2022 18:52:46 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyQrOe/2nD6sGhFCXpahGGtIY4+5WLhJVM3yDST0ldZgqwl1vti6nqV0jOL6lm6lUXjmpttDg==
X-Received: by 2002:a17:90b:4b8e:: with SMTP id lr14mr82858pjb.54.1643251966475;
        Wed, 26 Jan 2022 18:52:46 -0800 (PST)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id j15sm3583048pfj.102.2022.01.26.18.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Jan 2022 18:52:45 -0800 (PST)
Date:   Thu, 27 Jan 2022 10:52:42 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/2] generic: test suid/sgid behavior with reflink and
 dedupe
Message-ID: <20220127025242.yfw2h5vfw3lxbfep@zlang-mailbox>
Mail-Followup-To: "Darrick J. Wong" <djwong@kernel.org>,
        linux-xfs@vger.kernel.org, fstests@vger.kernel.org
References: <164316310323.2594527.8578672050751235563.stgit@magnolia>
 <164316310910.2594527.6072232851001636761.stgit@magnolia>
 <20220126055641.wnyawz3ooeqnwefi@zlang-mailbox>
 <20220127005556.GC13540@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220127005556.GC13540@magnolia>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Wed, Jan 26, 2022 at 04:55:56PM -0800, Darrick J. Wong wrote:
> On Wed, Jan 26, 2022 at 01:56:41PM +0800, Zorro Lang wrote:
> > On Tue, Jan 25, 2022 at 06:11:49PM -0800, Darrick J. Wong wrote:
> > > From: Darrick J. Wong <djwong@kernel.org>
> > > 
> > > Make sure that we drop the setuid and setgid bits any time reflink or
> > > dedupe change the file contents.
> > > 
> > > Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> > > ---
> > >  tests/generic/950     |  108 +++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/950.out |   49 ++++++++++++++++++++
> > >  tests/generic/951     |  118 +++++++++++++++++++++++++++++++++++++++++++++++++
> > >  tests/generic/951.out |   49 ++++++++++++++++++++
> > >  tests/generic/952     |   71 +++++++++++++++++++++++++++++
> > >  tests/generic/952.out |   13 +++++
> > >  6 files changed, 408 insertions(+)
> > >  create mode 100755 tests/generic/950
> > >  create mode 100644 tests/generic/950.out
> > >  create mode 100755 tests/generic/951
> > >  create mode 100644 tests/generic/951.out
> > >  create mode 100755 tests/generic/952
> > >  create mode 100644 tests/generic/952.out
> > > 
> > > 
> > > diff --git a/tests/generic/950 b/tests/generic/950
> > > new file mode 100755
> > > index 00000000..84f1d1f0
> > > --- /dev/null
> > > +++ b/tests/generic/950
> > > @@ -0,0 +1,108 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 950
> > > +#
> > > +# Functional test for dropping suid and sgid bits as part of a reflink.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto clone quick
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/reflink
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs generic
> > > +_require_user
> > > +_require_scratch_reflink
> > > +
> > > +_scratch_mkfs >> $seqres.full
> > > +_scratch_mount
> > > +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> > 
> > Is this a Darrick's secret helper ? :)
> 
> Oops, yes.  Will resend.
> 
> There's a big old patchset in djwong-dev that teaches all the reflink
> tests to _notrun if the file allocation unit is not congruent (i.e. an
> integer multiple or factor) with the operation sizes used in the test.
> 
> I should probably move that up in the branch, but with Lunar New Year
> starting next week there probably isn't much point... ;)

Sure, Happy Lunar New Year ("新春快乐") in advance :)

> 
> --D
> 
> > Thanks,
> > Zorro
> > 
> > > +chmod a+rw $SCRATCH_MNT/
> > > +
> > > +setup_testfile() {
> > > +	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
> > > +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> > > +	_pwrite_byte 0x57 0 1m $SCRATCH_MNT/b >> $seqres.full
> > > +	chmod a+r $SCRATCH_MNT/b
> > > +	sync
> > > +}
> > > +
> > > +commit_and_check() {
> > > +	local user="$1"
> > > +
> > > +	md5sum $SCRATCH_MNT/a | _filter_scratch
> > > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > > +
> > > +	local cmd="$XFS_IO_PROG -c 'reflink $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
> > > +	if [ -n "$user" ]; then
> > > +		su - "$user" -c "$cmd" >> $seqres.full
> > > +	else
> > > +		$SHELL -c "$cmd" >> $seqres.full
> > > +	fi
> > > +
> > > +	_scratch_cycle_mount
> > > +	md5sum $SCRATCH_MNT/a | _filter_scratch
> > > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > > +
> > > +	# Blank line in output
> > > +	echo
> > > +}
> > > +
> > > +# Commit to a non-exec file by an unprivileged user clears suid but leaves
> > > +# sgid.
> > > +echo "Test 1 - qa_user, non-exec file"
> > > +setup_testfile
> > > +chmod a+rws $SCRATCH_MNT/a
> > > +commit_and_check "$qa_user"
> > > +
> > > +# Commit to a group-exec file by an unprivileged user clears suid and sgid.
> > > +echo "Test 2 - qa_user, group-exec file"
> > > +setup_testfile
> > > +chmod g+x,a+rws $SCRATCH_MNT/a
> > > +commit_and_check "$qa_user"
> > > +
> > > +# Commit to a user-exec file by an unprivileged user clears suid but not sgid.
> > > +echo "Test 3 - qa_user, user-exec file"
> > > +setup_testfile
> > > +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> > > +commit_and_check "$qa_user"
> > > +
> > > +# Commit to a all-exec file by an unprivileged user clears suid and sgid.
> > > +echo "Test 4 - qa_user, all-exec file"
> > > +setup_testfile
> > > +chmod a+rwxs $SCRATCH_MNT/a
> > > +commit_and_check "$qa_user"
> > > +
> > > +# Commit to a non-exec file by root clears suid but leaves sgid.
> > > +echo "Test 5 - root, non-exec file"
> > > +setup_testfile
> > > +chmod a+rws $SCRATCH_MNT/a
> > > +commit_and_check
> > > +
> > > +# Commit to a group-exec file by root clears suid and sgid.
> > > +echo "Test 6 - root, group-exec file"
> > > +setup_testfile
> > > +chmod g+x,a+rws $SCRATCH_MNT/a
> > > +commit_and_check
> > > +
> > > +# Commit to a user-exec file by root clears suid but not sgid.
> > > +echo "Test 7 - root, user-exec file"
> > > +setup_testfile
> > > +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> > > +commit_and_check
> > > +
> > > +# Commit to a all-exec file by root clears suid and sgid.
> > > +echo "Test 8 - root, all-exec file"
> > > +setup_testfile
> > > +chmod a+rwxs $SCRATCH_MNT/a
> > > +commit_and_check
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/950.out b/tests/generic/950.out
> > > new file mode 100644
> > > index 00000000..b42e4931
> > > --- /dev/null
> > > +++ b/tests/generic/950.out
> > > @@ -0,0 +1,49 @@
> > > +QA output created by 950
> > > +Test 1 - qa_user, non-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > > +2666 -rw-rwSrw- SCRATCH_MNT/a
> > > +
> > > +Test 2 - qa_user, group-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > > +676 -rw-rwxrw- SCRATCH_MNT/a
> > > +
> > > +Test 3 - qa_user, user-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > > +2766 -rwxrwSrw- SCRATCH_MNT/a
> > > +
> > > +Test 4 - qa_user, all-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > > +777 -rwxrwxrwx SCRATCH_MNT/a
> > > +
> > > +Test 5 - root, non-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > > +
> > > +Test 6 - root, group-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > > +
> > > +Test 7 - root, user-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > > +
> > > +Test 8 - root, all-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > > +3784de23efab7a2074c9ec66901e39e5  SCRATCH_MNT/a
> > > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > > +
> > > diff --git a/tests/generic/951 b/tests/generic/951
> > > new file mode 100755
> > > index 00000000..99f67ab7
> > > --- /dev/null
> > > +++ b/tests/generic/951
> > > @@ -0,0 +1,118 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 951
> > > +#
> > > +# Functional test for dropping suid and sgid bits as part of a deduplication.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto clone quick
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/reflink
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs generic
> > > +_require_user
> > > +_require_scratch_reflink
> > > +_require_xfs_io_command dedupe
> > > +
> > > +_scratch_mkfs >> $seqres.full
> > > +_scratch_mount
> > > +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> > > +chmod a+rw $SCRATCH_MNT/
> > > +
> > > +setup_testfile() {
> > > +	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
> > > +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> > > +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/b >> $seqres.full
> > > +	chmod a+r $SCRATCH_MNT/b
> > > +	sync
> > > +}
> > > +
> > > +commit_and_check() {
> > > +	local user="$1"
> > > +
> > > +	md5sum $SCRATCH_MNT/a | _filter_scratch
> > > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > > +
> > > +	local before_freesp=$(_get_available_space $SCRATCH_MNT)
> > > +
> > > +	local cmd="$XFS_IO_PROG -c 'dedupe $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
> > > +	if [ -n "$user" ]; then
> > > +		su - "$user" -c "$cmd" >> $seqres.full
> > > +	else
> > > +		$SHELL -c "$cmd" >> $seqres.full
> > > +	fi
> > > +
> > > +	_scratch_cycle_mount
> > > +	md5sum $SCRATCH_MNT/a | _filter_scratch
> > > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > > +
> > > +	local after_freesp=$(_get_available_space $SCRATCH_MNT)
> > > +
> > > +	echo "before: $before_freesp; after: $after_freesp" >> $seqres.full
> > > +	if [ $after_freesp -le $before_freesp ]; then
> > > +		echo "expected more free space after dedupe"
> > > +	fi
> > > +
> > > +	# Blank line in output
> > > +	echo
> > > +}
> > > +
> > > +# Commit to a non-exec file by an unprivileged user clears suid but leaves
> > > +# sgid.
> > > +echo "Test 1 - qa_user, non-exec file"
> > > +setup_testfile
> > > +chmod a+rws $SCRATCH_MNT/a
> > > +commit_and_check "$qa_user"
> > > +
> > > +# Commit to a group-exec file by an unprivileged user clears suid and sgid.
> > > +echo "Test 2 - qa_user, group-exec file"
> > > +setup_testfile
> > > +chmod g+x,a+rws $SCRATCH_MNT/a
> > > +commit_and_check "$qa_user"
> > > +
> > > +# Commit to a user-exec file by an unprivileged user clears suid but not sgid.
> > > +echo "Test 3 - qa_user, user-exec file"
> > > +setup_testfile
> > > +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> > > +commit_and_check "$qa_user"
> > > +
> > > +# Commit to a all-exec file by an unprivileged user clears suid and sgid.
> > > +echo "Test 4 - qa_user, all-exec file"
> > > +setup_testfile
> > > +chmod a+rwxs $SCRATCH_MNT/a
> > > +commit_and_check "$qa_user"
> > > +
> > > +# Commit to a non-exec file by root clears suid but leaves sgid.
> > > +echo "Test 5 - root, non-exec file"
> > > +setup_testfile
> > > +chmod a+rws $SCRATCH_MNT/a
> > > +commit_and_check
> > > +
> > > +# Commit to a group-exec file by root clears suid and sgid.
> > > +echo "Test 6 - root, group-exec file"
> > > +setup_testfile
> > > +chmod g+x,a+rws $SCRATCH_MNT/a
> > > +commit_and_check
> > > +
> > > +# Commit to a user-exec file by root clears suid but not sgid.
> > > +echo "Test 7 - root, user-exec file"
> > > +setup_testfile
> > > +chmod u+x,a+rws,g-x $SCRATCH_MNT/a
> > > +commit_and_check
> > > +
> > > +# Commit to a all-exec file by root clears suid and sgid.
> > > +echo "Test 8 - root, all-exec file"
> > > +setup_testfile
> > > +chmod a+rwxs $SCRATCH_MNT/a
> > > +commit_and_check
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/951.out b/tests/generic/951.out
> > > new file mode 100644
> > > index 00000000..f7099ea2
> > > --- /dev/null
> > > +++ b/tests/generic/951.out
> > > @@ -0,0 +1,49 @@
> > > +QA output created by 951
> > > +Test 1 - qa_user, non-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > > +
> > > +Test 2 - qa_user, group-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > > +
> > > +Test 3 - qa_user, user-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > > +
> > > +Test 4 - qa_user, all-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > > +
> > > +Test 5 - root, non-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6666 -rwSrwSrw- SCRATCH_MNT/a
> > > +
> > > +Test 6 - root, group-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6676 -rwSrwsrw- SCRATCH_MNT/a
> > > +
> > > +Test 7 - root, user-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6766 -rwsrwSrw- SCRATCH_MNT/a
> > > +
> > > +Test 8 - root, all-exec file
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > > +310f146ce52077fcd3308dcbe7632bb2  SCRATCH_MNT/a
> > > +6777 -rwsrwsrwx SCRATCH_MNT/a
> > > +
> > > diff --git a/tests/generic/952 b/tests/generic/952
> > > new file mode 100755
> > > index 00000000..470d73bd
> > > --- /dev/null
> > > +++ b/tests/generic/952
> > > @@ -0,0 +1,71 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2022 Oracle.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 952
> > > +#
> > > +# Functional test for dropping suid and sgid capabilities as part of a reflink.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto clone quick
> > > +
> > > +# Import common functions.
> > > +. ./common/filter
> > > +. ./common/reflink
> > > +
> > > +# real QA test starts here
> > > +
> > > +# Modify as appropriate.
> > > +_supported_fs generic
> > > +_require_user
> > > +_require_command "$GETCAP_PROG" getcap
> > > +_require_command "$SETCAP_PROG" setcap
> > > +_require_scratch_reflink
> > > +
> > > +_scratch_mkfs >> $seqres.full
> > > +_scratch_mount
> > > +_require_congruent_file_oplen $SCRATCH_MNT 1048576
> > > +chmod a+rw $SCRATCH_MNT/
> > > +
> > > +setup_testfile() {
> > > +	rm -f $SCRATCH_MNT/a $SCRATCH_MNT/b
> > > +	_pwrite_byte 0x58 0 1m $SCRATCH_MNT/a >> $seqres.full
> > > +	_pwrite_byte 0x57 0 1m $SCRATCH_MNT/b >> $seqres.full
> > > +	chmod a+rwx $SCRATCH_MNT/a $SCRATCH_MNT/b
> > > +	$SETCAP_PROG cap_setgid,cap_setuid+ep $SCRATCH_MNT/a
> > > +	sync
> > > +}
> > > +
> > > +commit_and_check() {
> > > +	local user="$1"
> > > +
> > > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > > +	_getcap -v $SCRATCH_MNT/a | _filter_scratch
> > > +
> > > +	local cmd="$XFS_IO_PROG -c 'reflink $SCRATCH_MNT/b 0 0 1m' $SCRATCH_MNT/a"
> > > +	if [ -n "$user" ]; then
> > > +		su - "$user" -c "$cmd" >> $seqres.full
> > > +	else
> > > +		$SHELL -c "$cmd" >> $seqres.full
> > > +	fi
> > > +
> > > +	stat -c '%a %A %n' $SCRATCH_MNT/a | _filter_scratch
> > > +	_getcap -v $SCRATCH_MNT/a | _filter_scratch
> > > +
> > > +	# Blank line in output
> > > +	echo
> > > +}
> > > +
> > > +# Commit by an unprivileged user clears capability bits.
> > > +echo "Test 1 - qa_user"
> > > +setup_testfile
> > > +commit_and_check "$qa_user"
> > > +
> > > +# Commit by root leaves capability bits.
> > > +echo "Test 2 - root"
> > > +setup_testfile
> > > +commit_and_check
> > > +
> > > +# success, all done
> > > +status=0
> > > +exit
> > > diff --git a/tests/generic/952.out b/tests/generic/952.out
> > > new file mode 100644
> > > index 00000000..eac9e76a
> > > --- /dev/null
> > > +++ b/tests/generic/952.out
> > > @@ -0,0 +1,13 @@
> > > +QA output created by 952
> > > +Test 1 - qa_user
> > > +777 -rwxrwxrwx SCRATCH_MNT/a
> > > +SCRATCH_MNT/a cap_setgid,cap_setuid=ep
> > > +777 -rwxrwxrwx SCRATCH_MNT/a
> > > +SCRATCH_MNT/a
> > > +
> > > +Test 2 - root
> > > +777 -rwxrwxrwx SCRATCH_MNT/a
> > > +SCRATCH_MNT/a cap_setgid,cap_setuid=ep
> > > +777 -rwxrwxrwx SCRATCH_MNT/a
> > > +SCRATCH_MNT/a
> > > +
> > > 
> > 
> 

