Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D808BC433E0
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 08:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1B8A64E99
	for <linux-xfs@archiver.kernel.org>; Mon, 15 Mar 2021 08:41:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbhCOIlE (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 15 Mar 2021 04:41:04 -0400
Received: from verein.lst.de ([213.95.11.211]:52881 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229585AbhCOIkh (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Mon, 15 Mar 2021 04:40:37 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id BE66A68C4E; Mon, 15 Mar 2021 09:40:33 +0100 (CET)
Date:   Mon, 15 Mar 2021 09:40:33 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     Vivek Goyal <vgoyal@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Andy Lutomirski <luto@kernel.org>,
        Theodore Tso <tytso@mit.edu>, Alban Crequy <alban@kinvolk.io>,
        Tycho Andersen <tycho@tycho.ws>,
        Seth Forshee <seth.forshee@canonical.com>,
        =?iso-8859-1?Q?St=E9phane?= Graber <stgraber@ubuntu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge@hallyn.com>, linux-ext4@vger.kernel.org,
        linux-xfs@vger.kernel.org
Subject: Re: [PATCH v6 02/40] fs: add id translation helpers
Message-ID: <20210315084033.GB28612@lst.de>
References: <20210121131959.646623-1-christian.brauner@ubuntu.com> <20210121131959.646623-3-christian.brauner@ubuntu.com> <20210313000529.GA181317@redhat.com> <20210313143148.d6rhgmhxwq6abb6y@wittgenstein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210313143148.d6rhgmhxwq6abb6y@wittgenstein>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

> +	struct user_namespace *s_user_ns = sb->s_user_ns;
> +	if (!kuid_has_mapping(s_user_ns,
> +		kuid_from_mnt(mnt_userns, current_fsuid())))
> +		return false;
> +	if (!kgid_has_mapping(s_user_ns,
> +		kgid_from_mnt(mnt_userns, current_fsgid())))
> +		return false;
> +	return true;

Please don't use one tab indents for conditional continuations, as
that looks really weird.  Always use two tabs or align to the
opening brace.

Otherwise these helpers looks really useful.
