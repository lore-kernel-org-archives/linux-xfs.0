Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E1E112F5A5
	for <linux-xfs@vger.kernel.org>; Fri,  6 Sep 2024 13:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725629673; cv=none; b=RqdTlTwRhcB4g0Ke9vAeB/Uz5jTrf7NKK1ZaxK9XFag3xzl3FL/EpukyqlXn7QAifjCwrVY0y2AJeQ7/gHpsuWyrWmJlmRsi3A1MMqUheXTcKhg3aTdhMtGlUxrblIXdEt5ZLX26XcH+v0L0GRsAS12DN4m/RRQB+WFv1jXL8hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725629673; c=relaxed/simple;
	bh=fNrSfhfWEAv4rj8K4mWxBJXIQJuGoumiaG4TyCh46/Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qvCkrRKD9+sDBsOqrcJELnXOCPzMM5mjiBxTJheHJXH5+eEAgOS3jIgBI7UXYz48m43p9hns0mB5dGSSQs1R0CYn4t+FMa0Fbn0vxUPwkconQoaI988Sf/AsLkdulQOSVlg/2jhx00XQw8vbun5QC8cIeXg0ZxJ+RTLYwqvMpBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jX6l/jZk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jX6l/jZk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6F37C4CEC7;
	Fri,  6 Sep 2024 13:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725629672;
	bh=fNrSfhfWEAv4rj8K4mWxBJXIQJuGoumiaG4TyCh46/Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jX6l/jZkxibl9dkyM4tdK25glT4htuFCx/LMdtcyNL7FU6V+Uo8kYslZnr7lK5/0g
	 i1n/d72sH567k60HndXh2qrebZn3Jtu9fEOkOKsreXr8v0/GrbW+vfYXbr4WiepN+B
	 PseUnFUH/ktsZPckPA5MqAcN6vThVjjiPlRAGrxL070/5m1lASwI0CqB8Cij/mqI4Y
	 7iMg6pt5F8b4CxMCU/cQgcGSonepXvkDgHAlYLOnImvAcsyRZx1PXmbxayPmLKGhSb
	 qQzHZp+28Kxvl0NJ1J+QwnFjoHdAsq4h91cj89OflQlVm91NIh76XNEUG4QWtPuUt/
	 jdwPv7g9RW8tg==
Date: Fri, 6 Sep 2024 15:34:27 +0200
From: Carlos Maiolino <cem@kernel.org>
To: Gerald Yang <gerald.yang@canonical.com>
Cc: "Darrick J. Wong" <djwong@kernel.org>, sandeen@sandeen.net, 
	linux-xfs@vger.kernel.org
Subject: Re: [PATCH] fsck.xfs: fix fsck.xfs run by different shells when
 fsck.mode=force is set
Message-ID: <4wjwnz3tpf2beyx5begcblmv2q33ldsu6pitcklv47dbzxh24s@xdkogoscgzat>
References: <20240813072815.1655916-1-gerald.yang@canonical.com>
 <20240813145327.GE6051@frogsfrogsfrogs>
 <CAMsNC+vKDt21mLG_VZDyMXZkVOeMsQ45hU7D7gCvHj9HmT0DxQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMsNC+vKDt21mLG_VZDyMXZkVOeMsQ45hU7D7gCvHj9HmT0DxQ@mail.gmail.com>

On Fri, Sep 06, 2024 at 11:44:37AM GMT, Gerald Yang wrote:
> Thank you Darrick for the review
> I just would like to ask if this will be merged into for-next soon?

This is already in my queue, but got delayed due the problems with C++ compiler,
hopefully some day next week it should hit for-next.

Carlos

> 
> 
> On Tue, Aug 13, 2024 at 10:53 PM Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Tue, Aug 13, 2024 at 03:25:51PM +0800, Gerald Yang wrote:
> > > When fsck.mode=force is specified in the kernel command line, fsck.xfs
> > > is executed during the boot process. However, when the default shell is
> > > not bash, $PS1 should be a different value, consider the following script:
> > > cat ps1.sh
> > > echo "$PS1"
> > >
> > > run ps1.sh with different shells:
> > > ash ./ps1.sh
> > > $
> > > bash ./ps1.sh
> > >
> > > dash ./ps1.sh
> > > $
> > > ksh ./ps1.sh
> > >
> > > zsh ./ps1.sh
> > >
> > > On systems like Ubuntu, where dash is the default shell during the boot
> > > process to improve startup speed. This results in FORCE being incorrectly
> > > set to false and then xfs_repair is not invoked:
> > > if [ -n "$PS1" -o -t 0 ]; then
> > >         FORCE=false
> > > fi
> > >
> > > Other distros may encounter this issue too if the default shell is set
> > > to anoother shell.
> > >
> > > Check "-t 0" is enough to determine if we are in interactive mode, and
> > > xfs_repair is invoked as expected regardless of the shell used.
> > >
> > > Fixes: 04a2d5dc ("fsck.xfs: allow forced repairs using xfs_repair")
> > > Signed-off-by: Gerald Yang <gerald.yang@canonical.com>
> > > ---
> > >  fsck/xfs_fsck.sh | 4 ++--
> > >  1 file changed, 2 insertions(+), 2 deletions(-)
> > >
> > > diff --git a/fsck/xfs_fsck.sh b/fsck/xfs_fsck.sh
> > > index 62a1e0b3..19ada9a7 100755
> > > --- a/fsck/xfs_fsck.sh
> > > +++ b/fsck/xfs_fsck.sh
> > > @@ -55,12 +55,12 @@ fi
> > >  # directly.
> > >  #
> > >  # Use multiple methods to capture most of the cases:
> > > -# The case for *i* and -n "$PS1" are commonly suggested in bash manual
> > > +# The case for *i* is commonly suggested in bash manual
> > >  # and the -t 0 test checks stdin
> > >  case $- in
> > >       *i*) FORCE=false ;;
> >
> > I can't remember why we allow any argument with the letter 'i' in it to
> > derail an xfs_repair -f invocation??
> >
> > Regardless, the bits you changed look correct so
> > Reviewed-by: Darrick J. Wong <djwong@kernel.org>
> >
> > --D
> >
> > >  esac
> > > -if [ -n "$PS1" -o -t 0 ]; then
> > > +if [ -t 0 ]; then
> > >       FORCE=false
> > >  fi
> > >
> > > --
> > > 2.43.0
> > >
> > >
> 
