Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36BC544CF5E
	for <linux-xfs@vger.kernel.org>; Thu, 30 Apr 2026 15:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777564447; cv=none; b=Go0mz5l/7We5/Yrpl9Q7vaqKimBiwVMU2ZCzxqYqkPx1b5dmFhDwDBZUe+HcakEgjBCkujz5/c6x7OSko95MH8/IPQTwxWuK9uCOL4q6/N5oL5AjNHV+xRy5mJFlxKMVWomlGyUUU8uL75XZsr5RwsCBIm4OOZra37VrgHCt9r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777564447; c=relaxed/simple;
	bh=czWpTcg+sRN43i3nukYCEyJGPIUr9cZzBGf0snmwD40=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=cOle1PPgefwimcm9mmFZPxs5eIaEWTohqOFSabt6oGucHSebxDX9drEBhgme4spEoCgxgD8G4CSGOYINZcFjuw5PYK16GQI18E7lzHvkrvBIapFTm8bkTiTmQSV5HV5VOj6DfNWSBwHoF9KK3cGOcqH0L+xRB9zCqbX9IRxZ/1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1LkJOkt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1LkJOkt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD77DC2BCB3;
	Thu, 30 Apr 2026 15:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777564446;
	bh=czWpTcg+sRN43i3nukYCEyJGPIUr9cZzBGf0snmwD40=;
	h=Date:From:To:Cc:Subject:From;
	b=Q1LkJOktX8aoJExcU8sZzgJlTYnELijwzBy9DkhPkeNIqyIqDmrI3ctrOG2mOnruc
	 +wZ1aNWcF7+vSQok8BobKMZ6P/2IMBT5GCJX62yKu7dAgAWkR8iud+D0nas22uBdxI
	 3/YZDcQlt2AjyDuFgAqc0XOsCovgtSecMVmWjz6sg98+/mrHoBjPjhnwjP5bfQNu2z
	 4PG/3cJj3xOoOxWpQs9lPGhYgh0mQUlxaBcVOllKu8bG/zmqWbWMUA1WzS3UrRTYA4
	 RrsXFrxLoXdZD1qlcUEI4ISIpcwDGSMeb/3QhQB6nrV3A7CawgKKexwWjdtMjyWYeH
	 Hlif5cl0Tobcg==
Date: Thu, 30 Apr 2026 08:54:06 -0700
From: "Darrick J. Wong" <djwong@kernel.org>
To: Patrick Fischer <patrick.fischer@siedl.net>,
	Andrey Albershteyn <aalbersh@redhat.com>
Cc: linux-xfs@vger.kernel.org
Subject: [PATCH] xfs_scrub_all: fix deadlock if lsblk produces a lot of output
Message-ID: <20260430155406.GF7751@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

From: Darrick J. Wong <djwong@kernel.org>

Patrick Fischer reported a deadlock in find_mounts() that is the result
of lsblk producing so much output that it fills the pipe buffer.  When
this happens, lsblk blocks on write()ing the pipe, at which point
waiting for lsblk to exit will also block forever.

Now that we can be reasonably assured that everyone has Python 3.5
(because RHEL6 is long dead), we can replace this whole mess with a call
to subprocess.run that captures the output.  The json library can
convert a byte array directly to a python dict, which means we don't
need to concatenate iterated lines or any of that stuff anymore.

Reported-by: patrick.fischer@siedl.net
Link: https://lore.kernel.org/linux-xfs/323580211.1220195.1777554001363.JavaMail.zimbra@siedl.net/
Cc: <linux-xfs@vger.kernel.org> # v4.15.0
Fixes: f1dca11cad1308 ("xfs_scrub: create a script to scrub all xfs filesystems")
Signed-off-by: "Darrick J. Wong" <djwong@kernel.org>
---
 scrub/xfs_scrub_all.py.in |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/scrub/xfs_scrub_all.py.in b/scrub/xfs_scrub_all.py.in
index 9f861639a43ce4..dbb6c36e467d3f 100644
--- a/scrub/xfs_scrub_all.py.in
+++ b/scrub/xfs_scrub_all.py.in
@@ -53,15 +53,16 @@ def find_mounts():
 
 	fs = {}
 	cmd=['lsblk', '-o', 'NAME,KNAME,TYPE,FSTYPE,MOUNTPOINT', '-J']
-	result = subprocess.Popen(cmd, stdout=subprocess.PIPE)
-	result.wait()
-	if result.returncode != 0:
+	try:
+		proc = subprocess.run(cmd, capture_output = True, text = True, check = True)
+	except Exception as e:
+		print(e)
+		return fs
+	if proc.returncode != 0:
 		return fs
-	sarray = [x.decode(sys.stdout.encoding) for x in result.stdout.readlines()]
-	output = ' '.join(sarray)
-	bdevdata = json.loads(output)
 
 	# The lsblk output had better be in disks-then-partitions order
+	bdevdata = json.loads(proc.stdout)
 	for bdev in bdevdata['blockdevices']:
 		lastdisk = bdev['kname']
 		find_xfs_mounts(bdev, fs, lastdisk)
