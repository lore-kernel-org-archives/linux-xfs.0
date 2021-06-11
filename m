Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 492A5C48BE0
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 08:19:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 314B9613C1
	for <linux-xfs@archiver.kernel.org>; Fri, 11 Jun 2021 08:19:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbhFKIVi (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Fri, 11 Jun 2021 04:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229584AbhFKIVi (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Fri, 11 Jun 2021 04:21:38 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32F94C061574;
        Fri, 11 Jun 2021 01:19:41 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id k7so5277704pjf.5;
        Fri, 11 Jun 2021 01:19:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=references:user-agent:from:to:cc:subject:in-reply-to:date
         :message-id:mime-version;
        bh=P/dOSqu6agknJdYl5fuR6pGXlY/MiJQS9erU8oqbyYA=;
        b=M/Y6EJi6NOi2RPgvKR/FLqgWzr6aulnpFLOZMOwLaJ839mUy52GgTVU82agrtPXOXn
         vrCNJMdS0MhufuSjjV23khPE+wsT54yCatqSJap048DMyu8CjEw+5SCAynQXgTRfRF86
         uoig9Kp0HiLgcXHJ2ExWFJmDjqRmj08X2nI1WwDIBxQ5bXQaSy7zoooeauSHNYnu4kAp
         aEEGaznJie4xmFKtV7EZbyhEX26BfUdFxLtkA4hqU6MVyAsCCZuC31fLbwfnG4XD/a/4
         oNASdRHc2bcWKAcNQRtBaqO3nsLql/2xsN64D789imJX7ivtcGpm+G0gWQsW5I3Bs1bY
         acmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:references:user-agent:from:to:cc:subject
         :in-reply-to:date:message-id:mime-version;
        bh=P/dOSqu6agknJdYl5fuR6pGXlY/MiJQS9erU8oqbyYA=;
        b=IB1zB8mushdlUVLa18Bp0gJFCx8sugVBUTcC7sxCaYiI8ppS7zTAHWWowiryZKFRtz
         6ZmxndpCg6qMOLYsL2MGrYHZTBPOtNs8uogDV0VDktjHyun3iO67V0pQum6rNhqvFycE
         bEtw29mD0bHuL21nIdTY//b6/knQtfovJM/bzzc9FIZR2Um8hMM8TmzNl+8Zpa9qk0TQ
         aD9LQPvU79sAqw5Ss0WQeR5Afc5JKVFBFwNga/JKlRTlU060bNNpwpHvwd/fsgh7SnyF
         AMdA6njxWour2+I7IucWzxzZdO6gEqD8IaWVCQnguxGsyGWJymVitao1tnkjgf7GFgGP
         F1Ng==
X-Gm-Message-State: AOAM531126+/Rxov9tEEOIUTD0wY0W6723r9xvGkxUlM9dWzdy1sa/+M
        JMjMXz5ka/tS5OPR2kZtULs=
X-Google-Smtp-Source: ABdhPJw3KESxz3WtWY1h5fK+FEzSIMRiwVz6qPM0aW+3Ba8/wP0iB2vHJk+Cle8TdsAKbM1TLOhRLQ==
X-Received: by 2002:a17:90b:4b51:: with SMTP id mi17mr8060406pjb.109.1623399580524;
        Fri, 11 Jun 2021 01:19:40 -0700 (PDT)
Received: from garuda ([171.61.74.194])
        by smtp.gmail.com with ESMTPSA id w27sm4743755pfq.117.2021.06.11.01.19.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 11 Jun 2021 01:19:40 -0700 (PDT)
References: <162317276202.653489.13006238543620278716.stgit@locust> <162317282778.653489.13112698258806159936.stgit@locust>
User-agent: mu4e 1.0; emacs 26.1
From:   Chandan Babu R <chandanrlinux@gmail.com>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     guaneryu@gmail.com, linux-xfs@vger.kernel.org,
        fstests@vger.kernel.org, guan@eryu.me, amir73il@gmail.com,
        ebiggers@kernel.org
Subject: Re: [PATCH 12/13] fstests: remove test group management code
In-reply-to: <162317282778.653489.13112698258806159936.stgit@locust>
Date:   Fri, 11 Jun 2021 13:49:36 +0530
Message-ID: <87pmws3jaf.fsf@garuda>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On 08 Jun 2021 at 22:50, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
>
> Remove all the code that manages group files, since we now generate
> them at build time.
>

Looks good.

Reviewed-by: Chandan Babu R <chandanrlinux@gmail.com>

> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
>  tools/mvtest     |   12 ------
>  tools/sort-group |  112 ------------------------------------------------------
>  2 files changed, 124 deletions(-)
>  delete mode 100755 tools/sort-group
>
>
> diff --git a/tools/mvtest b/tools/mvtest
> index 572ae14e..fa967832 100755
> --- a/tools/mvtest
> +++ b/tools/mvtest
> @@ -32,24 +32,12 @@ did="$(basename "${dest}")"
>  sgroup="$(basename "$(dirname "tests/${src}")")"
>  dgroup="$(basename "$(dirname "tests/${dest}")")"
>  
> -sgroupfile="tests/${sgroup}/group"
> -dgroupfile="tests/${dgroup}/group"
> -
>  git mv "tests/${src}" "tests/${dest}"
>  git mv "tests/${src}.out" "tests/${dest}.out"
>  sed -e "s/^# FS[[:space:]]*QA.*Test.*[0-9]\+$/# FS QA Test No. ${did}/g" -i "tests/${dest}"
>  sed -e "s/^QA output created by ${sid}$/QA output created by ${did}/g" -i "tests/${dest}.out"
>  sed -e "s/test-${sid}/test-${did}/g" -i "tests/${dest}.out"
>  
> -grpline="$(grep "^${sid} " "${sgroupfile}")"
> -newgrpline="$(echo "${grpline}" | sed -e "s/^${sid} /${did} /g")"
> -
> -sed -e "/^${sid} .*$/d" -i "${sgroupfile}"
> -cp "${dgroupfile}" "${dgroupfile}.new"
> -append "${dgroupfile}.new" "${newgrpline}"
> -"${dir}/sort-group" "${dgroupfile}.new"
> -mv "${dgroupfile}.new" "${dgroupfile}"
> -
>  echo "Moved \"${src}\" to \"${dest}\"."
>  
>  exit 0
> diff --git a/tools/sort-group b/tools/sort-group
> deleted file mode 100755
> index 6fcaad77..00000000
> --- a/tools/sort-group
> +++ /dev/null
> @@ -1,112 +0,0 @@
> -#!/usr/bin/env python
> -import sys
> -
> -# Sort a group list, carefully preserving comments.
> -
> -def xfstest_key(key):
> -	'''Extract the numeric part of a test name if possible.'''
> -	k = 0
> -
> -	assert type(key) == str
> -
> -	# No test number at all...
> -	if not key[0].isdigit():
> -		return key
> -
> -	# ...otherwise extract as much number as we can.
> -	for digit in key:
> -		if digit.isdigit():
> -			k = k * 10 + int(digit)
> -		else:
> -			return k
> -	return k
> -
> -def read_group(fd):
> -	'''Read the group list, carefully attaching comments to the next test.'''
> -	tests = {}
> -	comments = None
> -
> -	for line in fd:
> -		sline = line.strip()
> -		tokens = sline.split()
> -		if len(tokens) == 0 or tokens[0] == '#':
> -			if comments == None:
> -				comments = []
> -			comments.append(sline)
> -		else:
> -			tests[tokens[0]] = (comments, tokens[1:])
> -			comments = None
> -	return tests
> -
> -def sort_keys(keys):
> -	'''Separate keys into integer and non-integer tests.'''
> -	int_keys = []
> -	int_xkeys = []
> -	str_keys = []
> -
> -	# Sort keys into integer(ish) tests and other
> -	for key in keys:
> -		xkey = xfstest_key(key)
> -		if type(xkey) == int:
> -			int_keys.append(key)
> -			int_xkeys.append(xkey)
> -		else:
> -			str_keys.append(key)
> -	return (int_keys, int_xkeys, str_keys)
> -
> -def write_sorted(tests, fd):
> -	def dump_xkey(xkey):
> -		(comments, tokens) = tests[key]
> -		if comments:
> -			for c in comments:
> -				fd.write('%s\n' % c)
> -		fd.write('%s %s\n' % (key, ' '.join(tokens)))
> -	'''Print tests (and comments) in number order.'''
> -
> -	(int_keys, ignored, str_keys) = sort_keys(tests.keys())
> -	for key in sorted(int_keys, key = xfstest_key):
> -		dump_xkey(key)
> -	for key in sorted(str_keys):
> -		dump_xkey(key)
> -
> -def sort_main():
> -	if '--help' in sys.argv[1:]:
> -		print('Usage: %s groupfiles' % sys.argv[0])
> -		sys.exit(0)
> -
> -	for arg in sys.argv[1:]:
> -		with open(arg, 'r+') as fd:
> -			x = read_group(fd)
> -			fd.seek(0, 0)
> -			write_sorted(x, fd)
> -
> -def nextid_main():
> -	if '--help' in sys.argv[1:]:
> -		print('Usage: %s group[/startid] ' % sys.argv[0])
> -		sys.exit(0)
> -
> -	if len(sys.argv) != 2:
> -		print('Specify exactly one group name.')
> -		sys.exit(1)
> -
> -	c = sys.argv[1].split('/')
> -	if len(c) > 1:
> -		startid = int(c[1])
> -	else:
> -		startid = 1
> -	group = c[0]
> -
> -	with open('tests/%s/group' % group, 'r') as fd:
> -		x = read_group(fd)
> -		xkeys = {int(x) for x in sort_keys(x.keys())[1]}
> -
> -		xid = startid
> -		while xid in xkeys:
> -			xid += 1
> -		print('%s/%03d' % (group, xid))
> -
> -if __name__ == '__main__':
> -	if 'nextid' in sys.argv[0]:
> -		nextid_main()
> -	else:
> -		sort_main()


-- 
chandan
