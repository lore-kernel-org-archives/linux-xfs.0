Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 27EE17F52
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 17:24:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D8A858F8050
	for <xfs@oss.sgi.com>; Tue,  9 Sep 2014 15:24:54 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id Fl7GSJZW8Ud95wo3 for <xfs@oss.sgi.com>;
	Tue, 09 Sep 2014 15:24:52 -0700 (PDT)
Message-ID: <540F7E37.7020500@sandeen.net>
Date: Tue, 09 Sep 2014 17:24:55 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Corrupted files
References: <540F1B01.3020700@mygrande.net>	<CAA43vkXwHF9RHW-cbTZ91_vF6wiQ6o_+TQDL3=7kD9P4tErCNQ@mail.gmail.com>
	<CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>
In-Reply-To: <CAA43vkWgh8-EjDXjkySUn+y18W1O+v_W5j+fQankRTgDCmc8tw@mail.gmail.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Sean Caron <scaron@umich.edu>, Leslie Rhorer <lrhorer@mygrande.net>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 9/9/14 11:03 AM, Sean Caron wrote:

>Barring rare cases, xfs_repair is bad juju.

No, it's not.  It is the appropriate tool to use for filesystem repair.

But it is not the appropriate tool for recovery from mangled storage.

I've actually been running a filesystem fuzzer over xfs images, randomly
corrupting data and testing repair, 1000s of times over.  It does
remarkably well.

If you scramble your raid, which means your block device is no longer
an xfs filesystem, but is instead a random tangle of bits and pieces of
other things, of course xfs_repair won't do well, but it's not the right
tool for the job at that stage.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
