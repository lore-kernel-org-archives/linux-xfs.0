Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6CFF311C07;
	Tue, 16 Jun 2026 13:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781618247; cv=none; b=RJyGwbEs6DO9lpROSh+POJgFYk3gUpaJBArjKUxg1kTQOj2R71FOiGJpLlyVQKKWJA6HGdShr+WVODQcNtOD4LX5P0t76NmXDYxWzDmURbl3l4kbLEtWl+Ee9UzIG26CyUI5R5JQaQ3vJKHxcYdf/vAMWmFnt1t54u+nk0AeEVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781618247; c=relaxed/simple;
	bh=dEv4TOGSS8IHr9PQkQWz+S0T+jy2Jk3mRCS2j6YJ/Us=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DD2stm8hshMKxfTA97euFKtIg0swRxQdvtdT+lb2k8ndzbUr6tHgCZjQdbNoYSn988U+SuZgBehUVZnfiiMmiSTFo4E8cUX+1RM9NaCYFZa7Pl5h0qvwUxi2GNMsFokmu2HSxAz3OPM+ti0NSLpMRLxUweiWbXbhngd8J2wXPqo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o2PnEnYx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o2PnEnYx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40D6F1F000E9;
	Tue, 16 Jun 2026 13:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781618246;
	bh=2HQDPl4Fge9D8LBQD7QCKGIXM2QN58OYRKHRC0rBkGU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=o2PnEnYxJOrqBmCTljOBgmtEqnsmtt4iSTaJauqZ6cxnQ+mR+iXvcyycJR1kFvcCe
	 yWUyoeAwVH4s8tQiUkJCdHppm3BEkHIAYGBXKDK+Hc4qWA8olKjWoGLXQxnq4PcQtW
	 rP6FZaoqCE/Fi8EeG9QlgoFJndtCWvd1CfTRCL2Kumkaxi6ZhYDy7upSrUZCpbFs1c
	 WWmBs/k495pgDYgSPRlL82RAGWDEmEWKxobGoZqVROdWYlhx3mv61s4bx/kkuzdaKF
	 sCbqTj2qfBjiaxGGrTPVZIBdv0jG4izkN/6lviMsMkM52YxSA7t+LjS6/DxzGY16yX
	 EG2wVnsWfHqFA==
Message-ID: <bdfdbd6b-81e0-49e3-a02f-2dc75727a71b@kernel.org>
Date: Tue, 16 Jun 2026 15:57:21 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v2 0/5] Add buffered write-through support to iomap &
 xfs
To: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Cc: linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 djwong@kernel.org, john.g.garry@oracle.com, willy@infradead.org, hch@lst.de,
 ritesh.list@gmail.com, jack@suse.cz, Luis Chamberlain <mcgrof@kernel.org>,
 dgc@kernel.org, tytso@mit.edu, p.raghav@samsung.com, andres@anarazel.de,
 brauner@kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 pankaj.raghav@linux.dev, Daniel Gomez <da.gomez@samsung.com>
References: <cover.1775658795.git.ojaswin@linux.ibm.com>
 <d5d99db2-9d34-4caf-bcc8-c4a3af561901@kernel.org>
 <agQPtTx2EXHr10Nn@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
 <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
In-Reply-To: <ah24DlQobLjjDTGt@li-dc0c254c-257c-11b2-a85c-98b6c1322444.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 01/06/2026 18.49, Ojaswin Mujoo wrote:
> On Wed, May 13, 2026 at 11:14:21AM +0530, Ojaswin Mujoo wrote:
>> On Mon, May 04, 2026 at 09:54:49AM +0200, Daniel Gomez wrote:
>>> On 08/04/2026 20.45, Ojaswin Mujoo wrote:
> diff --git a/ltp/fsx.c b/ltp/fsx.c
> index 720bca83..1c76634b 100644
> --- a/ltp/fsx.c
> +++ b/ltp/fsx.c
> @@ -2077,16 +2077,34 @@ test_dontcache_io(void)
>         return 1;
>  }
> 
> +/*
> + * Use a temporary file to test RWF_WRITETHROUGH so as to not modify the
> + * original. This is so that fsx expected contents and the actual contents
> + * of the original file don't go out of sync
> + */
>  int
>  test_writethrough_io(void)
>  {
>         char buf[4096];
> +       char tmpname[PATH_MAX];
> +       int tmp_fd;
>         struct iovec iov = { .iov_base = buf, .iov_len = sizeof(buf) };
>         int ret, e;
> 
> +       snprintf(tmpname, sizeof(tmpname), "%s.fsx.XXXXXX", fname);
> +
> +       tmp_fd = mkstemp(tmpname);
> +       if (fd < 0) {
> +               perror("test_writethrough_io: mkstemp() failed\n");
> +               exit(132);
> +       }
> +
>         memset(buf, '\0', sizeof(buf));
> -       ret = pwritev2(fd, &iov, 1, 0, RWF_WRITETHROUGH);
> +       ret = pwritev2(tmp_fd, &iov, 1, 0, RWF_WRITETHROUGH);
>         e = ret < 0 ? errno : 0;
> +
> +       close(tmp_fd);
> +
>         if (e == EOPNOTSUPP) {
>                 if (!quiet)
>                         fprintf(stderr,
> 


I think this is missing:

@@ -2158,12 +2175,6 @@ test_writethrough_io(void)
                return 0;
        }

-       if (ftruncate(fd, file_size) != 0) {
-               perror("test_writethrough_io: failed to ftruncate to 0\n");
-               exit(132);
-       }
-
-

The fix works for me after a stress loop test on generic/457.

> 
> Im unable to replicate the 415 failure, but this one is strange because it
> doesn't involve any writethrough IO. In you previous runs have you seen
> this be flaky?

I couldn't confirm back then, so I think we can ignore it. Also, unrelated.

> 
> Admittedly, I've not yet started thorough testing since this is in early
> RFC and the design is still getting finalized but I appriciate the help
> in testing this.


No problem. IMHO, testing makes a design more robust, once the path is
agreed on. That said, do you think the path needs changing? Reading LWN
and the patch series threads, I don't see any blocker. You can cc me for
the next iteration and I'll follow up with more testing.
