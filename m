Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79B5536F90C;
	Tue, 23 Jun 2026 10:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209648; cv=none; b=ovVPA0AZYFbBfxfbcXkga4KFpmW4KfUbpeqBVCHd54rJAHsyobrVQqmo4zY4Lf4UfOfcsoZsqVk5hyVY+EFGE+zBfksTvFByNWjqsgL9JHKydTsaKVzWdqiRdEmaFInEQvNDuHQXgLK0DlqgbKiesendJKMDagHuBJ3ABI8BygE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209648; c=relaxed/simple;
	bh=IWTrcRd2o7VKbxsUGEodjdVeBd/La1Mw6CSkzIMgVG0=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=hgn1cxI7UW/nd2B/sDIuMWTkRFYDBOBD2uPHWclu+rYK+ubmJqJfBeX2uIXNJZA4qFW8tb1XR6ObbdK6tCH0e1X7cdKfvhkpwfmaSG9ak8CRJAjsDxfE6PEmXVEQf9nJN5q9cGgK8DNKi28NInAqL9ZlN3I2v03RRhN2iyJ3Fq0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X66kPjuQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X66kPjuQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F6F1F000E9;
	Tue, 23 Jun 2026 10:14:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782209647;
	bh=vtWsU0XCFa6NKrktmgpHdHW3vqPrmoOAPGugptWf8XM=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=X66kPjuQL1R1Evqe/K6M8qW4WdJCnvx6fj+yPcVoh7NWgn9cEHItYoI1TPZEkZvz7
	 7WAu7DKUbySEK2bFo4XZd80xIqyNvaUhZygUXXw8YWkqGQRws/T6+zU2lsgZnpyi1u
	 qDCMjRhPjLZc0eeWFlcrZP88M+u0Rjx5UpwG3o3HKgtlRIwIWAk77QLnZ+1T/k9Xid
	 Sr8maVIGguXZEmOpaEGTJStKLscU4Kxrcn0r6kefREApyZY1Lexnz84GVu12t2BM9L
	 QnOhrNxACW+6JEjI3wUys7A+I/YUJgfbqevkqLjnNDwcQX8lyc0lN784NoIW4G++WP
	 Db1AUvK5XH8qg==
From: Christian Brauner <brauner@kernel.org>
To: jack@suse.cz, linux-fsdevel@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>, 
 linux-mm@kvack.org, Usama Arif <usama.arif@linux.dev>
Cc: hughd@google.com, boris@bur.io, clm@fb.com, dsterba@suse.com, 
 linux-btrfs@vger.kernel.org, cem@kernel.org, linux-xfs@vger.kernel.org, 
 shakeel.butt@linux.dev, hannes@cmpxchg.org, riel@surriel.com, 
 kernel-team@meta.com
In-Reply-To: <20260609123047.1948242-1-usama.arif@linux.dev>
References: <20260609123047.1948242-1-usama.arif@linux.dev>
Subject: Re: [PATCH] fs/super: skip non-memcg-aware nr_cached_objects in
 memcg slab shrink
Message-Id: <20260623-drohbrief-messbar-gassen-43977ca126dd@brauner>
Date: Tue, 23 Jun 2026 12:14:00 +0200
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16-dev-8bbda
X-Developer-Signature: v=1; a=openpgp-sha256; l=921; i=brauner@kernel.org;
 h=from:subject:message-id; bh=IWTrcRd2o7VKbxsUGEodjdVeBd/La1Mw6CSkzIMgVG0=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWRZxWTrRl8TS67ItLn9yN8k84/yyWjTsz9eOEyP0bi2S
 YFh0cU1HaUsDGJcDLJiiiwO7Sbhcst5KjYbZWrAzGFlAhnCwMUpABN5pcjI8P3d5t6/KZeTjVyn
 Zr+KiPjWzvuk+92Blc5z/u1gedL04jUjw6UQh7eJ3K2n/H9bxCpsL52zUCckz9ZgpteqzozJPnY
 FTAA=
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624

On Tue, 09 Jun 2026 05:30:47 -0700, Usama Arif wrote:
> fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink

Applied to the vfs-7.3.misc branch of the vfs/vfs.git tree.
Patches in the vfs-7.3.misc branch should appear in linux-next soon.

Please report any outstanding bugs that were missed during review in a
new review to the original patch series allowing us to drop it.

It's encouraged to provide Acked-bys and Reviewed-bys even though the
patch has now been applied. If possible patch trailers will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. If in doubt, please check the listed branch.

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git
branch: vfs-7.3.misc

[1/1] fs/super: skip non-memcg-aware nr_cached_objects in memcg slab shrink
      https://git.kernel.org/vfs/vfs/c/5eacee52be6b

