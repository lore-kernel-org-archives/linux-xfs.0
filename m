Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 637D53A48C2;
	Wed,  1 Jul 2026 08:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782894157; cv=none; b=FAGwYqEVYYZ1ux5SHB+ElB7h/3y0M0poNH1A4FL9lPdbfee0YrAp3gT6AeMBRph1DqS4/JhrWJBCAJUMd91tTCO6L+dIWvo3oGinrqPqhQ9624ibnX7JPBVK7ea0oOJ4DTioMjVNUaFe0UpSD4BIILjG/Tgpq321GvlPOQNUDYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782894157; c=relaxed/simple;
	bh=HZ03r89dHiGdgs7Wjvpdbt7BSOOuOkL0oF4z+0mcAcE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CI4wOiJi4IR8+6v6AiD0SeOsBMH+gBHDz/5Cce4pnY0ZPWvZkJkLYsNyTdi5wgP2xdrH7s7/AVcMliJm2JXoTpvJQOXMuCO2Z6cFmYkYWAVIG67DR7ccfI6kwF3WL2iW3GehwnPzjIRunwb7Yag/0pizGRsil9PB/Q1eo/VjXMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KVEFr2+k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KVEFr2+k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F21CD1F000E9;
	Wed,  1 Jul 2026 08:22:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782894153;
	bh=hrJMDyzsiXGM+qo9pHWwqxLVblQQb1h6SX0y913VALE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KVEFr2+kSIloj1ZKE7fvW5zvaN6Kx9oY6ux54H2llciY/4rgngMNc3GCQjPB8UE5m
	 zYVJ7KPdRLHbhzPyzHTGzgwCwFpvrHXTs1uIkaQBgjFJeRjW7teNJpxTceFVHTzF16
	 bh8vRaxIGoxr/8IjJ5nX83K6gshh9GEJCGqGox9jhqp6iEFkTLCWNPgaBmJ0qLLtGg
	 4kAfXnTkoqHJfpromW84m8TWHH79vEVtHrVw4x2jzlcqHTSAnxALbtr8vv1EUWbKg1
	 geHG+u0tiCRMIfRFp8WZFPfxm+6V49B5k85hRt2UGfN7IhtCSrwLcs/nHZcA8Qmz0w
	 mP98LAn98kPpw==
Date: 
From: Daniel Gomez <da.gomez@kernel.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Chuck Lever <cel@kernel.org>, kdevops@lists.linux.dev, tools@kernel.org, GOST <gost.dev@samsung.com>, Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>, Carlos Maiolino <cem@kernel.org>, Chandan Babu R <chandanbabu@kernel.org>, David Sterba <dsterba@suse.com>, Song Liu <liu.song.a23@gmail.com>, Scott Mayhew <smayhew@redhat.com>, Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>, Konstantin Ryabitsev <mricon@kernel.org>, linux-xfs@vger.kernel.org, Darrick J. Wong <djwong@kernel.org>, Carlos Maiolino <cem@kernel.org>, Zorro Lang <zlang@kernel.org>, fstests@vger.kernel.org
Subject: Re: kdevops-ng: graduating kdevops beyond Ansible
Message-ID: <20260701011751.0-da.gomez@kernel.org>
In-Reply-To: a9e73c72b603e64724bf64fb1a7b4e6a045ed386.camel@kernel.org
References: 9f64bee9-ecc3-4587-9645-2190223cbc4e@kernel.org a9e73c72b603e64724bf64fb1a7b4e6a045ed386.camel@kernel.org
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Mailer: lorebird



On 2026-06-18T08:31:51-04:00, Jeff Layton <jlayton@kernel.org> wrote:
> On Thu, 2026-06-18 at 11:30 +0200, Daniel Gomez wrote:
> > kdevops is a framework for Linux kernel development and test automation.
> > Its core features, namely workflow reproducibility, variability, and
> > scalability, are delivered through Kconfig, the variability language,
> > and Ansible, which provides host and guest idempotency along with
> > workflow orchestration at scale, whether on baremetal, local VMs, or
> > the cloud.
> > 
> > kdevops supports rolling distributions such as Debian testing, Fedora,
> > and openSUSE. Recently we extended Nix support, which raised the
> > question: how do we drive Nix's declarative language from Ansible? We
> > answered by wiring Nix in under Ansible and its templates, as one more
> > way to declare host and guest environments. But that was the wrong
> > framing: we had bolted Nix onto today's toolkit instead of rethinking
> > it. Reproducibility and idempotency now come from Nix by construction,
> > so I think Ansible's original reason for being in kdevops falls away.
> > The better question is: how do we keep kdevops's core principles, lean
> > on Nix, and drop Ansible?
> > 
> > What remains once you do is not the configuration management plane. It
> > is development workflow orchestration: build QEMU, build the kernel,
> > build a guest rootfs/closure, boot it, run a test, collect results,
> > diff against a baseline. That work is imperative and sequenced, work
> > for a workflow engine, which is where tools like Windmill [1] come in.
> > Windmill calls itself as "the fastest workflow engine" and an
> > "open-source developer platform to power your entire infra and turn
> > scripts into webhooks, workflows and UIs." Choosing to move kdevops
> > onto Windmill would keep what made kdevops kdevops, namely workflows,
> > quick bring-ups, baselines, and A/B regression detection, while trading
> > Kconfig, Make, Ansible, and host-distro provisioning for typed
> > run-forms, flows as code, and a worker queue. Nix supplies the
> > environment, much like a container or venv/poetry, along with the guest
> > OS system closure: declarative and portable. Windmill orchestrates the
> > whole pipeline end to end, graduating kdevops into a fully reproducible,
> > scalable, and configurable kernel-development framework, with both a UI
> > and a CLI, that runs locally or in the cloud. Defined as code and driven
> > by schedules and triggers, the same flows also make it a continuous
> > integration pipeline. Because steps can be written in any language
> > Windmill supports, including Ansible, Bash, Go, Python, and Rust,
> > developers can not only use kdevops but extend it with their own
> > scripts, turning it into a workflow hub. Note that choosing this path
> > does not mean NixOS is required on the controller node; Nix is simply a
> > runtime dependency that can be installed alongside your distro of
> > choice.
> > 
> > It'd be good to know what folks think about the possibility of evolving
> > kdevops in this direction, deprecating Ansible along with Kconfig and
> > Makefiles in favor of the new approach. To that end, I suggest a demo
> > day where I can show why I think this is the next step worth taking, and
> > whether it's a tradeoff users and maintainers are willing to make.
> >
> > If this is of interest and you'd like a look, I've ported equivalents of
> > bootlinux (direct boot), qemu-build, and the systemd/QEMU bringup (QSU),
> > plus an fstests run for XFS in the proof-of-concept demo project [2].
> > You can also find some screenshots in [3].
> > 
> > A note on licensing. Windmill's engine is AGPLv3; its OpenFlow flow
> > format and client libraries are Apache-2.0. kdevops-ng runs Windmill
> > unmodified and self-hosted as a separate service, and the flows and
> > scripts are kdevops-ng's own copyleft-next-0.3.1 code, executed by
> > Windmill rather than derived from it, so there shouldn't be any
> > licensing concerns.
> > 
> > [1] https://windmill.dev
> > [2] https://github.com/dagomez137/kdevops-ng
> > [3] https://github.com/dagomez137/kdevops-ng/tree/main/screenshots
>
> Some thoughts:
>
> I'd be interested to see the demo.  It's a little hard to make a
> judgment about moving it in this direction without knowing specifically
> what it would look like.  I took a quick look at the git repo and the
> windmill site, but I don't really "get it" yet.

+cc xfs folks.

I have published a documentation website here:
https://kdevops-ng.readthedocs.io/en/latest/

It covers the project's concepts, terminology, deployment, roadmap and more.
I've also included a demo video to showcasing how to build the kernel
and run the fstest suite for XFS and review the results (all in Windmill UI):

https://kdevops-ng.readthedocs.io/en/latest/getting-started/demos.html

I'd also like to suggest holding an office hours session toward the end of 
this month (in about four weeks), so we can discuss about this, questions, etc.


