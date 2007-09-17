Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 17 Sep 2007 07:15:13 -0700 (PDT)
Received: from oplss0036.barcap.com (oplss0036.barclayscapital.com [141.228.156.166])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8HEF5uw027006
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2007 07:15:08 -0700
Received: from oplss0036.barcap.com (localhost [127.0.0.1])
	by oplss0036.barcap.com (8.13.7/8.11.4) with ESMTP id l8HDurVP008156
	for <xfs@oss.sgi.com>; Mon, 17 Sep 2007 14:56:53 +0100 (BST)
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Subject: RE: Configuring XFS on Redhat Linux
Date: Mon, 17 Sep 2007 22:15:04 +0800
Message-ID: <53F49A183F99D94D9C84E062566A97E3037C6E4C@SGPPCMEU302VEUA.INTRANET.BARCAPINT.COM>
In-reply-to: <46E94DEC.3090404@sandeen.net>
From: <Kumaraswamy.Namburu@barclayscapital.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: sandeen@sandeen.net
Cc: xfs@oss.sgi.com

 
Hello Sandeen,

  Thank you very much for your mail. I am new to Linux Kernel
Compilation. Could you please advise me the steps involved in enabling
xfs filesystem on Linux version 2.6.9-22.Elsmp. I have  googled and
tried few methods, but I have failed to enable XFS, Infact my machine is
not booting up after xfs module installation. Please help me.

Kind Regards,
       kumaraswamy Namburu
>Development Tools Team
>http://devtoolswiki
>* developmenttools
>* General Team Hotline : 87731250 
>* Direct : +65 68284827  
>* Mobile : +65 91137662  
      Barclays Capital, Singapore. 

-----Original Message-----
From: Eric Sandeen [mailto:sandeen@sandeen.net] 
Sent: 13 September 2007 22:49
To: Namburu, Kumaraswamy: IT (SGP)
Cc: xfs@oss.sgi.com
Subject: Re: Configuring XFS on Redhat Linux

Kumaraswamy.Namburu@barclayscapital.com wrote:
> Hello All,
> 
>   Following is the configuration of the server
>   Linux version 2.6.9-22.ELsmp (root@yort.fnal.gov) (gcc version 3.4.3
20050227 (Red Hat 3.4.3-22.1)) #1 SMP Thu Oct 6 10:29:1
>   Linux engpsrcn01.intranetdev.barcapdev.com 2.6.9-22.ELsmp #1 SMP Thu
Oct 6 10:29:17 CDT 2005 x86_64 x86_64 x86_64 GNU/Linux
>   From Inside our compant, I am unable to connect to cvs server at
port 2041. Could you please let me know the alternative ways to get the
source code.

unless you really need cvs, how about http via kernel.org?  or the git
tree? http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git

If you want xfs for your 2.6.9-22.ELsmp kernel, you might just grab the
xfs kernel module packages & xfs userspace from the Centos distribution.

Or, since it looks like you're using scientific linux and not actually
RHEL, maybe just ask them.

-Eric

------------------------------------------------------------------------
For important statutory and regulatory disclosures and more information about Barclays Capital, please visit our web site at http://www.barcap.com.

Internet communications are not secure and therefore the Barclays Group does not accept legal responsibility for the contents of this message.  Although the Barclays Group operates anti-virus programmes, it does not accept responsibility for any damage whatsoever that is caused by viruses being passed.  Any views or opinions presented are solely those of the author and do not necessarily represent those of the Barclays Group.  Replies to this email may be monitored by the Barclays Group for operational or business reasons.

Barclays Capital is the investment banking division of Barclays Bank PLC, a company registered in England (number 1026167) with its registered office at 1 Churchill Place, London, E14 5HP. This email may relate to or be sent from other members of the Barclays Group.
------------------------------------------------------------------------
