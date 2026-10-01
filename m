Received: from phd-imap.ethz.ch (phd-imap.ethz.ch [129.132.80.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86588518133
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 13:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=129.132.80.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790862952; cv=none; b=RE+TCh3hN2kN0cZ/MyIPBmDhRx466CXdIpqKkyPYoW78PVD7EE/WPfUAJMrM1XOE+/JsvfBbf0/Q7udpHD6sR2LWrl2VPL5mjcAdcyq78k7oLo7jT7+U8EDGhXCaHQhT26yPvX7+P+/yxrM10wtjNyKo3c28FWMslKJ8B+9qxGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790862952; c=relaxed/simple;
	bh=lJ6zo1c2K/SEzYRNlfSifxreyHuqnpxPzWNnWLI6W3o=;
	h=MIME-Version:Date:From:To:Subject:Message-ID:Content-Type; b=K8CACGABkVS/7S255su9XPYoWFJbPBz6obJvGmlkMHefL+NA/Gir8UW4DAiXVNhwJq+L9Yfi/DCJGdNNnAFG4NPDW30ZS6PihDP4UQTCPmZQJmfTsOIuy8i2Nn2KpuwmEpuLy22g+biTV6IgKGw7m7/XMtBwUom9A9E0IsJgfBw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=phys.ethz.ch; spf=pass smtp.mailfrom=phys.ethz.ch; dkim=pass (2048-bit key) header.d=phys.ethz.ch header.i=@phys.ethz.ch header.b=IVPkuOS3; arc=none smtp.client-ip=129.132.80.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=phys.ethz.ch
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=phys.ethz.ch
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=phys.ethz.ch header.i=@phys.ethz.ch header.b="IVPkuOS3"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=phys.ethz.ch;
	s=2023; t=1790862358;
	bh=9eikwA34cYlRauXJcgtN5qyDwaW8+mpP+Z8x39JlMgc=;
	h=Date:From:To:Subject:From;
	b=IVPkuOS3XHUpYfiu+OE/kTeG9bL31d6xKWHSP/cLpTimcQpLxXyHjelWNjgTUt8qg
	 xPjMQ3QvAqNKhUECwyvfO49vLYWkaphM8OHl/NSywFXmNyMsre6G+qHkbsKzWixVAc
	 vN9q7kG9QMiUlVyx/5KxQqGmf3NZe9plXwuOIr0pIjSw6BVkQOavmJMvCJ3quglhkj
	 zmv5L/XlhSFfcIpqmUl7lQ5nSh6FC3x1yL3aHcQcKkLQUWSQ/BIghNVHrMh/spwocA
	 oRcoFJTtVFABMYwM8sosS9dSJgqmJQRPMxNgA8zdXTiHgD7Qr6SnNqldzrobgM3hqb
	 NCgYt2Ga9bRag==
Received: from localhost (192-168-127-49.net4.ethz.ch [192.168.127.49])
	by phd-imap.ethz.ch (Postfix) with ESMTP id 4hwY8k3lfWzCX
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 15:45:58 +0200 (CEST)
X-Virus-Scanned: Debian amavis at phys.ethz.ch
Received: from phd-mxin.ethz.ch ([192.168.127.53])
 by localhost (phd-mailscan.ethz.ch [192.168.127.49]) (amavis, port 10024)
 with LMTP id R5QHbs7BrxhX for <linux-xfs@vger.kernel.org>;
 Thu,  1 Oct 2026 15:45:58 +0200 (CEST)
Received: from webmail.phys.ethz.ch (192-168-127-51.net4.ethz.ch [192.168.127.51])
	by phd-mxin.ethz.ch (Postfix) with ESMTP id 4hwY8k2jY6zM1
	for <linux-xfs@vger.kernel.org>; Thu,  1 Oct 2026 15:45:58 +0200 (CEST)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 01 Oct 2026 15:45:58 +0200
From: Stephan Mueller <stepmueller@phys.ethz.ch>
To: linux-xfs@vger.kernel.org
Subject: rw stat clarification
Message-ID: <4103a3f702be0ccf0e6eeb34981b3d65@phys.ethz.ch>
X-Sender: stepmueller@phys.ethz.ch
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit

Hi there

/sys/fs/xfs/$FS/stats/stats has a counter "rw" showing read and write 
call counters. The output is actually

rw #writes #reads  // eg first writes, than reads

This is quite confusing (at least for me), when the metric is called 
"rw" suggesting first reads, then writes. Also the docs [1] call it "rw 
- Read/Write Stats" but then list the fields in the correct order

   - xs_write_calls
   - xs_read_calls

May I go ahead and make it

rw #reads #writes

or better not break people's scripts and just add a clarification to 
docs?

   Have a nice day
   stephan

[1] https://xfs.org/index.php/Runtime_Stats#rw_-_Read/Write_Stats
