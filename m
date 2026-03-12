Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F1D3242C8
	for <linux-xfs@vger.kernel.org>; Thu, 12 Mar 2026 23:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773358733; cv=none; b=q3oiziGPmO6sDzOJZ2B7CRr0u2cJNa17GwghINzhYysslyp+5oGsK0GQokEEpfMM0oAIb6aUcRanAr/X/vZjl1TjH516c67N2rybCV8qozDEC9BMhOailtmllglda1ne2pc+BiOrN99aJ2BpHU4xP4KJLjf0mMetOPkIQLX58Uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773358733; c=relaxed/simple;
	bh=PjQnm7PdIi0z/ruBJQNhneZVuQrhBMEPnKL7b5RdF4s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mHOn912MrD9Mv4A7skBR0PKUAd2YQONvoGuwmegZk+aLI9xDD64Nugvzp0iJt4bxlkIkoSwd5wWoP6lhbKURLpIEvFTAfF8iFVn0f6tUGppkidhOO0VZp2fruKxRiTKt/8m8dYiPUK2EujsuU6cB8wBkEbJ+7EAzu6l1zAKT4i0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org; spf=pass smtp.mailfrom=goodmis.org; arc=none smtp.client-ip=216.40.44.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=goodmis.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=goodmis.org
Received: from omf04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7466A58E55;
	Thu, 12 Mar 2026 23:38:47 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf04.hostedemail.com (Postfix) with ESMTPA id 437DE20024;
	Thu, 12 Mar 2026 23:38:32 +0000 (UTC)
Date: Thu, 12 Mar 2026 19:38:47 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: NeilBrown <neilb@ownmail.net>
Cc: NeilBrown <neil@brown.name>, Linus Torvalds
 <torvalds@linux-foundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Jeff
 Layton <jlayton@kernel.org>, Trond Myklebust <trondmy@kernel.org>, Anna
 Schumaker <anna@kernel.org>, Carlos Maiolino <cem@kernel.org>, Miklos
 Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>, Jan
 Harkes <jaharkes@cs.cmu.edu>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, David Howells <dhowells@redhat.com>, Marc
 Dionne <marc.dionne@auristor.com>, Steve French <sfrench@samba.org>, Namjae
 Jeon <linkinjeon@kernel.org>, Sungjong Seo <sj1557.seo@samsung.com>,
 Yuezhang Mo <yuezhang.mo@sony.com>, Andreas Hindborg
 <a.hindborg@kernel.org>, Breno Leitao <leitao@debian.org>, "Theodore Ts'o"
 <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Masami
 Hiramatsu <mhiramat@kernel.org>, Ilya Dryomov <idryomov@gmail.com>, Alex
 Markuze <amarkuze@redhat.com>, Viacheslav Dubeyko <slava@dubeyko.com>,
 Tyler Hicks <code@tyhicks.com>, Andreas Gruenbacher <agruenba@redhat.com>,
 Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Jeremy Kerr <jk@ozlabs.org>, Ard Biesheuvel
 <ardb@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
 linux-unionfs@vger.kernel.org, coda@cs.cmu.edu, linux-mm@kvack.org,
 linux-afs@lists.infradead.org, linux-cifs@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
 ecryptfs@vger.kernel.org, gfs2@lists.linux.dev,
 linux-um@lists.infradead.org, linux-efi@vger.kernel.org
Subject: Re: [PATCH RFC 00/53] lift lookup out of exclive lock for dir ops
Message-ID: <20260312193847.28c32a2c@gandalf.local.home>
In-Reply-To: <20260312214330.3885211-1-neilb@ownmail.net>
References: <20260312214330.3885211-1-neilb@ownmail.net>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Stat-Signature: uw6f48jbt5c7m69ogen7zm3qrgdgnged
X-Rspamd-Server: rspamout08
X-Rspamd-Queue-Id: 437DE20024
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX188/YrC5TApof6JUD5+VNztl2shXsvgY5o=
X-HE-Tag: 1773358712-902307
X-HE-Meta: U2FsdGVkX1+OxQ2+Isx7vF4UixzzITSWoLGanhQdmOUQzHc1ErHaC2HhfFr20UjnVfuApzdY0CnNI9X2EzaFzoxWkp+inh8h89+ue9tsCje/WXI2p8TViZKD1rgZ9aRmWPzAaOFt9AR3SlccruGvmKX1nd3X2qcHF/Qj4v2Ic2F2kBtdL+HvK1KWscULRrzA7ZXclvIVR+DpEPprYwt/KKB72qtNEyxLFZN/ZdoFOmgI0OmUW9WSqFmPDtGp6NNUkGL68vmGr0d1dJsWkcANTfDGT58FCBs3Q3TWI/CNur9ihaDpBPfKeDQH86AL8k3ONIIfeCwhZyBEr7FfTAOuyi2fOWNNYZopJrxvZi0zu3x2dKf/Woo8mIogKoo/MSw6

On Fri, 13 Mar 2026 08:11:47 +1100
NeilBrown <neilb@ownmail.net> wrote:

> *[PATCH 26/53] smb/client: don't unhashed and rehash to prevent new
> *[PATCH 27/53] smb/client: use d_splice_alias() in atomic_open
>  [PATCH 28/53] smb/client: Use d_alloc_noblock() in
> *[PATCH 29/53] exfat: simplify exfat_lookup()
> *[PATCH 30/53] configfs: remove d_add() calls before
>  [PATCH 31/53] configfs: stop using d_add().
> *[PATCH 32/53] ext4: move dcache modifying code out of __ext4_link()
> *[PATCH 33/53] ext4: use on-stack dentries in

>  [PATCH 34/53] tracefs: stop using d_add().

Hmm, another reason I hate being Cc'd on every patch of a patch bomb where
I only need to look at one (and maybe the first) patch.

For some reason, I'm missing several patches, and this is one of them :-p

-- Steve


>  [PATCH 35/53] cephfs: stop using d_add().
> *[PATCH 36/53] cephfs: remove d_alloc from CEPH_MDS_OP_LOOKUPNAME
>  [PATCH 37/53] cephfs: Use d_alloc_noblock() in
>  [PATCH 38/53] cephfs: Don't d_drop() before d_splice_alias()
>  [PATCH 39/53] ecryptfs: stop using d_add().
>  [PATCH 40/53] gfs2: stop using d_add().
