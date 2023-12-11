Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C058B3B7BB
	for <linux-xfs@vger.kernel.org>; Mon, 11 Dec 2023 12:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Uw+XzfJT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58BE5C433C9;
	Mon, 11 Dec 2023 12:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702299254;
	bh=hSIiiydE/0p/C4wIFT0WIRtqDNrFRtLrBDZ1Hmn4bM4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Uw+XzfJT8fZ1ObvR87YzER/2KNU7inJm6nlqxeqHd2+UINJCSvaUCsbKmeFvDk2JJ
	 tVQc2decDHL7iR8MQ6CoWIY9UebqOg/ZkiXO5GMg35YAoSNx8zVxC7GddGt+Mxk/WK
	 LHlwhbhXtVCI8P7V0UJ1nGZtm/snTDrjqEBdnnFlvtqFz07jfVfW+EueG9e77Cn+K7
	 R6fFKL5VW4B+l3awj7B2JnEWGNW6wrA8vsEWz24ySmbOLYpS8akqV2B73Z7drLuvBh
	 c03cIwwABdXSFDWBehHGqEwoeul16jcF0L16Ei+Fxz8y+MYBAbsb5hS0FTMdTCNyh1
	 OA5REMxv0dEhw==
Date: Mon, 11 Dec 2023 13:54:10 +0100
From: Carlos Maiolino <cem@kernel.org>
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Cc: linux-xfs@vger.kernel.org
Subject: Re: Project quota, info and advices
Message-ID: <nnrf2wdvgoxhsjl36hehjk65lnoaokbicgn3hm6da7gjam3p7a@55tyky4i6gym>
References: <y_iHWQadOHAveGWR036lUyTXPo_6BeLQPZJ0_1Oxz30PTpBAP2ab04i36GA4sdbz3hcnKnDexHcUOVY-AlUP2g==@protonmail.internalid>
 <CAJH6TXiDN2nUzCem5bcYf=kbbcQjhzxwAmP1JQZBD0TnQb9cfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJH6TXiDN2nUzCem5bcYf=kbbcQjhzxwAmP1JQZBD0TnQb9cfg@mail.gmail.com>

On Fri, Dec 08, 2023 at 04:00:51PM +0100, Gandalf Corvotempesta wrote:
> Hi all
> for two new mail server and web server (different machines) i'm
> planning to use XFS project
> quotas to limit how much space each user could use.
> 
> They are all virtual users so i can't rely on user quota and i was
> thinking to use project quota with directory-based settings.
> 
> In example:
> 
> /var/mail/domain1.tld 1GB
> /var/mail/domain2.tld 500MB
> 
> /var/mail is the XFS filesystem
> 
> Some questions:
> 1. are the usage of config files and numerical IDs mandatory ? Because
> i'm fetching config from a db and I prefere to not mess with ID.

config files are not mandatory, IDs are. Under the hood, IDs are what the
filesystem use to keep track of projects, the config files are merely a
convenience to translate ids into names (with one exception).

> 2. i've seen that if I remove the directory /var/mail/domain1.tld, the
> related project is still showing in the quota report, but if I
> recreate the directory, the quota is not honored anymore.

You remove the directory, you also remove all the metadata associated with that,
which include project quota flags. Once you create the directory again, you need
to set it up quotas for that directory again.

> 3. how can I delete a single project if not needed anymore?

You need to clear it by using 'project -C' argument, but to do so, the project
must be listed in the config files (the exception I mentioned above).

> 4. can I use multiple quotas for the same path, in example
> /domain1.tld 1GB, /domain1.tld/mailbox1 500MB /domain1.tld/mailbox2
> 500MB (allowing, in example, 2 different mailboxes, 500MB each and
> still 1GB from the parent direcory)

I believe you mean multiple quotas for the same mount point? All the examples
you gave here are different paths, if so, then yes, you can use different
project quotas for different directories under the same mount point.

Carlos
